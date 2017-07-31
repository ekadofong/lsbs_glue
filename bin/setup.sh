#!/bin/bash

head_dir=$(dirname $(dirname $(dirname ${BASH_SOURCE[0]})))
head_dir=$(readlink -f $head_dir)

#// set up lsst stack
#scl enable devtoolset-3 bash
source  /tigress/HSC/LSST/stack_tiger/loadLSST.bash
setup lsst_apps
#setup pipe_drivers
setup obs_subaru

#// free-floating python modules

find_repo ()
{
REPO_NAME="$1"

initdirs=$(find $head_dir/repos/$REPO_NAME -name "__init__.py") \
python - << 'EOF'
import os
import re

lpath = os.path.commonprefix ( os.environ['initdirs'].split() ) 
if re.match(".*/__init__.py", lpath):
    lpath = os.path.dirname ( lpath )

print (lpath )

EOF

}

while IFS=: read repo
do
    REPO_DIR=$(dirname $(find_repo $repo))
    echo "$REPO_DIR loaded"
    export PYTHONPATH=$REPO_DIR:${PYTHONPATH}
done < $head_dir/lsbs_glue/repos.cfg

#export PATH=${PATH}