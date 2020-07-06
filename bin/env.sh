#!/usr/bin/env bash

source ./settings.sh

# echo "Getting environment information for Slurm Docker Service."
# if ! ( cd ${GW_SLURM_DIR}			&& bash ./bin/env.sh ); then
# 	print_error_and_exit
# fi
# echo "Getting environment information for Virtuoso Docker Service."
# if ! ( cd ${GW_VIRTUOSO_DIR} 		&& bash ./bin/env.sh ); then
# 	print_error_and_exit
# fi
# echo "Getting environment information for GRPC/Delegator Docker Service."
# if ! ( cd ${GW_GRPC_DIR} 			&& bash ./bin/env.sh ); then
# 	print_error_and_exit
# fi
# echo "Getting environment information for Django Docker Service."
# if ! ( cd ${GW_DJANGO_DIR} 			&& bash ./bin/env.sh ); then
# 	print_error_and_exit
# fi
# echo "Getting environment information for Wordpress Docker Service."
# if ! ( cd ${GW_WORDPRESS_DIR} 		&& bash ./bin/env.sh ); then
# 	print_error_and_exit
# fi
echo "Getting environment information for Proxy Docker Service."
if ! ( cd ${GW_PROXY_DIR} 			&& bash ./bin/env.sh ); then
	print_error_and_exit
fi

# EXIT_SUCCESS
exit 0
