### eks-asg-tests

#### Directories structure
```bash
eks-asg-tests/
├── .circleci
└── terraform
    ├── aws_state       # (1) create s3/dynamodb state bucket/table
    ├── aws_infra       # (2) create aws project inrastructure
    └── aws_infra_apps  # (3) create ingress controller and monitoring apps
```
---

#### CircleCI

##### Contexts (Organization settings --> Context)
1. production (`env-prod` context)
    * `CI_ENVIRONMENT` --> `production`
    * `AWS_REGION`
2. staging (`env-staging` context)
    * `CI_ENVIRONMENT`  --> `staging`
    * `AWS_REGION`

##### Project vars (Project settings --> Environment Variables)
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_DEFAULT_REGION` (need to initialize tf state S3 bucket)

---
#### Terraform

* [Versions](terraform\aws_infra\versions.tf)
* [Production vars](terraform\aws_infra\production.tfvars)
* [Staging vars](terraform\aws_infra\production.tfvars)


###### [Managing TF state](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)

* **S3 bucket name** --> `${CIRCLE_PROJECT_REPONAME}`
* **S3 bucket key** --> `${CI_ENVIRONMENT}/${AWS_REGION}/terraform.tfstate`
* **S3 bucket init region** --> `${AWS_DEFAULT_REGION}`
* **DynamoDB locks tablename** --> `${CIRCLE_PROJECT_REPONAME}-tfstate-locks`