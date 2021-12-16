#!/bin/bash
# requires bashisms

# xournalpp-git
echo -e "\\e[33m====> Updating xournalpp-git...\\e[0m"
git clone git@github.com:eleanor-clifford/xournalpp.git
cd xournalpp
git remote add upstream https://github.com/xournalpp/xournalpp.git
git fetch upstream
git rebase upstream/master
read -p "Ok? (y/N) " yn
if echo $yn | egrep -q '^(y|Y)'; then
	if ! git push -f origin master; then
		exit 1
	fi
	cd -
	rm -rf xournalpp
	curl https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD\?h\=xournalpp-git \
		> xournalpp-git/PKGBUILD
	sed -i 's|^url=.*|url="https://github.com/eleanor-clifford/xournalpp"|' \
		xournalpp-git/PKGBUILD
	sed -i 's|^source=.*|source=("${_pkgname}::git+${url}.git")|' \
		xournalpp-git/PKGBUILD
else
	exit 1
fi

# oblogout (just check it)
echo -e "\\e[33m====> Checking oblogout...\\e[0m"
pkgver="$(sed -n 's|pkgver=||p' oblogout/PKGBUILD)"
pkgrel="$(sed -n 's|pkgrel=||p' oblogout/PKGBUILD)"

upstream_PKGBUILD="$(curl https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=oblogout)"
upstream_pkgver="$(echo "$upstream_PKGBUILD" | sed -n 's|pkgver=||p')"
upstream_pkgrel="$(echo "$upstream_PKGBUILD" | sed -n 's|pkgrel=||p')"

if ! [ "$pkgver" = "$upstream_pkgver" ] || ! [ "$pkgrel" = "$upstream_pkgrel" ];
then
	echo -e "\\e[31m====> oblogout: upstream has been updated\\e[0m"
fi
