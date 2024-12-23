#!/bin/bash -x

echo "##################### EXECUTE: kurento_bower_publish #####################"
# Parameter management
# FILES string
#   List of files to be placed in bower repo. It consist of a of pairs
#   SRC_FILE:DST_FILE separated by white space. All paths are relative to
#   project root
#
# REFSPEC string
#   Git reference in both: code and bower repositories where changes are
#   commited. Default value is the repo default branch.
#
# CREATE_TAG true | false
#   Whether a TAG must be created in bower repository. Default value is false
#
# BOWER_REPO_NAME string
#   Name of the Git repo which contains Bower files

# Validate parameters
[ -z "$FILES" ] && exit 1
# If no checkout reference, use the repo default branch.
[ -z "$REFSPEC" ] && REFSPEC="$(git_default_branch.sh)"
[ -z "$CREATE_TAG" ] && CREATE_TAG=false
[ -z "$BOWER_REPO_NAME" ] && BOWER_REPO_NAME="${KURENTO_PROJECT}-bower"

# Checkout to reference in source code repository
git checkout $REFSPEC || git checkout -b $REFSPEC origin/$REFSPEC || exit 1

# Get information from source code
COMMIT_LOG=$(git log -1 --oneline)
COMMIT_ID=$(echo $COMMIT_LOG|cut -d' ' -f1)
COMMIT_MSG=$(echo $COMMIT_LOG|cut -d' ' -f2-)
MESSAGE="Code autogenerated from Kurento/${KURENTO_PROJECT}@${COMMIT_ID}"
VERSION="$(get_version.sh)" || {
  echo "[kurento_bower_publish] ERROR: Command failed: get_version.sh"
  exit 1
}

# Checkout bower repo
BOWER_DIR="bower_code"
[ -d $BOWER_DIR ] && rm -rf $BOWER_DIR

# Do not declare error if bower repository does not exist
clone_repo.sh "$BOWER_REPO_NAME" "" "$BOWER_DIR" \
|| { echo "[kurento_bower_publish] WARNING: Command failed: clone_repo.sh $BOWER_REPO_NAME"; exit 0; }

cd $BOWER_DIR || exit 1

# Fail if a tag for that version already exists
if [[ "$CREATE_TAG" == "true" ]] && [[ $VERSION != *-SNAPSHOT ]]; then
  # If tag already exists terminate silently
  git ls-remote --tags|grep -q "refs/tags/$VERSION" && exit 0
fi

git checkout $REFSPEC || git checkout -b $REFSPEC || exit 1
git pull origin $REFSPEC || exit 1
# Remove all files checked out except git ones

REMOVE_FILES=$(ls -1)
for FILE in $REMOVE_FILES
do
  echo "Removing file $FILE"
  rm -r $FILE
done

# Copy files
for FILE in $FILES
do
  SRC_FILE=../$(echo $FILE|cut -d":" -f 1)
  DST_FILE=$(echo $FILE|cut -d":" -f 2)
  DST_DIR=$(dirname $DST_FILE)
  mkdir -p $DST_DIR
  echo "Moving file: $SRC_FILE ==> $DST_FILE"
  cp $SRC_FILE $DST_FILE || exit 1
done

# Add files
git add .
git status

# Check if a commit is required
if [ $(git status --porcelain|wc -l) -gt 0 ]; then
	echo "Commit changes to bower: $MESSAGE"
	git commit -a -m "$MESSAGE" || exit 1
	git push origin $REFSPEC || exit 1
fi

# Check if a version has to be generated
if [[ "$CREATE_TAG" == "true" ]] && [[ $VERSION != *-SNAPSHOT ]]; then
  echo "Add Tag version: $VERSION"

  # Add tag
  git tag -a -m "$MESSAGE" "$VERSION" || exit 1
  git push origin --follow-tags || exit 1
fi
