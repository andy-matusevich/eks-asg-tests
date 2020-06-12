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

##### Environments (`CI_ENVIRONMENT` var in Organization settings --> Context)
1. production (`env-prod` context)
2. staging (`env-staging` context)

##### Project vars (Project settings --> Environment Variables)
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_DEFAULT_REGION`
* `AWS_REGION`

---
#### Terraform

* [Versions](terraform\infra\versions.tf)
* [Production vars](terraform\infra\production.tfvars)
* [Staging vars](terraform\infra\production.tfvars)

