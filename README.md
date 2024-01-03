# Build Component

This action will create a new build of a Nuon component.

This is a composite action that uses the [Nuon CLI](https://docs.nuon.co/quickstart#installing-the-cli-and-terraform-provider). If you need a more sophisticated integration, you can use the CLI directly from your Github Action workflows (or any other automation platform.)

Refer to [our docs](https://docs.nuon.co) for more information on builds, releases, and the Nuon platform generally.

## Inputs

- org_id: Your Nuon org ID.
- api_token: A valid Nuon API token for your org.
- component_id: The ID of the component you want to update and deploy.

## Outputs

- build_id: The ID of the build that was created.

## Example Usage

The typical use-case for this action is to run it when updates are made to your component config or source code. For example:

```yaml
on:
  push:
    branches:
      - main
    paths:
      - 'components/my-component/**'
      - 'nuon/my-component.tf'
jobs:
  build:
    runs-on: ubuntu-latest
    name: Build
    steps:
      - name: Checkout code
        id: checkout
        uses: actions/checkout@v2
      - name: Build component
        id: build
        uses: nuonco/actions-build@v1
        with:
          api_token: ${{ secrets.nuon_api_token }}
          org: ${{ vars.nuon_org_id }}
          component_id: ${{ vars.nuon_component_id }}
```

You can also combine this with the [release action](https://github.com/nuonco/actions-release) to create a new build and release it.

```yaml
on:
  push:
    branches: main
    paths:
      - 'components/my-component/**'
      - 'nuon/my-component.tf'
jobs:
  deploy:
    runs-on: ubuntu-latest
    name: Deploy
    steps:
      - name: Build
        id: build
        uses: nuonco/actions-build@v1
        with:
          api_token: ${{ secrets.nuon_api_token }}
          org: ${{ vars.nuon_org_id
          component_id: ${{ vars.nuon_component_id }}
      - name: Release
        id: release
        uses: nuonco/actions-release@v1
        with:
          api_token: ${{ secrets.nuon_api_token }}
          org: ${{ vars.nuon_org_id
          build_id: ${{ steps.build.outputs.build_id }}
```
