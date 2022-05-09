#!/bin/bash

ARCHIVE=govcore-$1

composer create-project --stability beta --no-install drupal/legacy-project:~9.1.0 $ARCHIVE
composer dump-autoload
composer configure-tarball $ARCHIVE

cd $ARCHIVE
composer config minimum-stability dev
composer config prefer-stable true
composer config repositories.assets composer https://asset-packagist.org
composer remove --no-update composer/installers
composer update

# Add the version number to the info file.
echo "version: $1" >> ./profiles/contrib/govcore/govcore.info.yml

# Wrap it all up in a nice compressed tarball.
cd ..
tar --exclude='.DS_Store' --exclude='._*' -c -z -f $ARCHIVE.tar.gz $ARCHIVE

# Clean up.
rm -r -f $ARCHIVE
