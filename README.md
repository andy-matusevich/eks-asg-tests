### eks-asg-tests

#### Directories structure
```bash
eks-asg-tests/
├── .circleci
└── terraform
    ├── infra
    └── pre
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

* [Versions](terraform\infra\versions.tf)
* [Production vars](terraform\infra\production.tfvars)
* [Staging vars](terraform\infra\production.tfvars)


###### [Managing TF state](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)

* **S3 bucket name** --> `${CIRCLE_PROJECT_REPONAME}`
* **S3 bucket key** --> `${CI_ENVIRONMENT}/${AWS_REGION}/terraform.tfstate`
* **S3 bucket init region** --> `${AWS_DEFAULT_REGION}`
* **DynamoDB locks tablename** --> `${CIRCLE_PROJECT_REPONAME}-tfstate-locks`
* bucket --> `${CIRCLE_PROJECT_REPONAME}`