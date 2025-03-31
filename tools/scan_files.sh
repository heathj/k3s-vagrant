chsh -s /bin/bash www-data
su -p www-data -c 'php ./occ files:scan --all'