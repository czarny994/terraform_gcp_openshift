# terraform_gcp_openshift

## Setup

Before you ran terraform please set this variables

```bash
export TF_VAR_ocp_password="<your-secure-password>"
export TF_VAR_project_id="<your-gcp-project-id>"
```

```bash
terraform graph > graph.dot

sed -i '' '2i\
  rankdir=LR;\
  nodesep=1;\
  ranksep=1.5;\
' graph.dot

dot -Tpng graph.dot > graph.png
```