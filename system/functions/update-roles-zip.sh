#!/bin/zsh
set -e

cluster_name=$1
zip_dir=${2:-~/Downloads/roles-signing-key}
mkdir -p $zip_dir
zip_parent_dir=$(dirname $zip_dir)

k8s_manifests_dir=~/Code/click/k8s-manifests
role_manager_dir=$k8s_manifests_dir/rolemanager
overlay_dir=$role_manager_dir/overlays/$cluster_name

echo "cluster name: $cluster_name"
echo "overlay directory: $overlay_dir"
echo "zip directory: $zip_dir"

working_dir=$(pwd)

zip_overlay_dir=$zip_dir/$cluster_name
mkdir -p $zip_overlay_dir

cp $overlay_dir/kustomization.yaml $zip_overlay_dir
cp $overlay_dir/role-manager/roles-signing-key.pem $zip_overlay_dir
cp $overlay_dir/roles-signing-pubkey.pem $zip_overlay_dir
cp $overlay_dir/roles.json $zip_overlay_dir

cd $zip_parent_dir
zip_dir_basename=$(basename $zip_dir)
timestamp=$(date +"%Y%m%d")

zip -r roles-signing-key-$timestamp.zip $zip_dir_basename/
