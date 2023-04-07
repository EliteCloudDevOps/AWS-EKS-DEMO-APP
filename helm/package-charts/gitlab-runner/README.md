# GitLab Runner Helm Chart

This chart deploys a GitLab Runner instance into your Kubernetes
cluster. For more information, please review [our documentation](https://docs.gitlab.com/charts/charts/gitlab/gitlab-runner).

helm upgrade --install --create-namespace -n gitlab-runner gitlab-runner -f gitlab-runner/values.yaml gitlab/gitlab-runner

curl  --header "PRIVATE-TOKEN: glpat-8WT4QbXKATkdH_yenqxX" "https://gitlab.com/api/v4/runners"|jq '.[].id'|while read -r line; do command curl --request DELETE --header "PRIVATE-TOKEN: glpat-8WT4QbXKATkdH_yenqxX" "https://gitlab.com/api/v4/runners/$line"; done
