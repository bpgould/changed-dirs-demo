# changed-dirs-demo

This example repo shows how to set up GitHub Actions (or Travis CI) to run a bash script that identifies changed files in a particular directory.

On a Pull Request, it will compare files in the set directory with the current HEAD of the main main branch.

On a Push, it will identify changed files in the set directory from the current commit.

This is useful for mono-repo type operations or when you want your CI to respond to changed files only in a specific directory, matching specific crieria.

One example is for Terraform. If you have multiple Terraform environments in a single repo with their own states, you would want to loop over them and perform your Terraform CI proccess.

A potential Terraform repo could look like:

/terraform
  - /test
    - main.tf
    - vars.tf
    - backend.tf
  - /staging
    - main.tf
    - vars.tf
    - backend.tf
  - /prod
    - main.tf
    - vars.tf
    - backend.tf

Wouldn't it be nice to only run the terraform CI commands like `terraform fmt` and `terraform plan` on environments that change? This can save a lot of build time when enviornments become large.

I know what you are thinking: what about catching config drift in unmodified environments?

> Answer: run a cronjob that forces CI to run on all environments and programatically open GitHub Issues for environments containing drift. I have actually implemented this solution before at scale.

Note: an easy way to identify drift is to check for anything existing in the plan. That will not catch all drift, but it is a good start.
