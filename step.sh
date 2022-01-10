#!/bin/bash
set -x

pod repo add ${repo_name} ${podspec_repo_url}

cat ${podspec}

if [ "$skip_validation" = "no" ]
then
  pod repo push ${repo_name} ${podspec} --skip-tests --skip-import-validation --allow-warnings --sources=${podspec_sources}
else
  REPO_PATH=$(pod repo list | grep -o "[[:alnum:]/\.]*/${repo_name}$")

  NAME=$(jq -r '.name' ${podspec})
  VERSION=$(jq -r '.version' ${podspec})

  mkdir -p "$REPO_PATH/$NAME/$VERSION"

  ACTION=""

  PODSPEC_NAME=$(basename ${podspec})

  if [[ -f "$REPO_PATH/$NAME/$VERSION/$PODSPEC_NAME" ]]
  then
    ACTION="[Fix]"
  else
    ACTION="[Add]"
  fi

  cp ${podspec} "$REPO_PATH/$NAME/$VERSION/$PODSPEC_NAME"

  cd $REPO_PATH

  git add --all
  git commit -m "$ACTION $NAME ($VERSION)"
  git push origin master

fi
