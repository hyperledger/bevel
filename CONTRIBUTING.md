# Contributing

Thank you for your interest to contribute to Hyperledger Bevel!

We welcome contributions to Hyperledger Bevel in many forms, and
there's always plenty to do!

First things first, please review the [Hyperledger Code of Conduct](https://wiki.hyperledger.org/display/HYP/Hyperledger+Code+of+Conduct) before participating and please follow it in all your interactions with the project.

You can contibute to Hyperledger Bevel, as a user or/and as a developer.

##### As a user:

[Making Feature/Enhancement Proposals](https://github.com/hyperledger/bevel/issues/new?assignees=&labels=enhancement&template=feature_request.md&title=)   
[Reporting bugs](https://github.com/hyperledger/bevel/issues/new?assignees=&labels=bug&template=bug_report.md&title=)

##### As a developer:

Consider picking up a [“help-wanted”](https://github.com/hyperledger/bevel/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) or ["good-first-issue"](https://github.com/hyperledger/bevel/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22) task  

If you can commit to full-time/part-time development, then please contact us on our [Rocketchat channel](https://chat.hyperledger.org/channel/bevel ) to work through logistics!

Please visit the
[Developer Guide](https://hyperledger-bevel.readthedocs.io/en/latest/developerguide/) in the docs to learn how to make contributions to this exciting project.

 #### Pull Request Process :

For source code integrity , Hyperledger Bevel GitHub pull requests are accepted from forked repositories only. There are also quality standards identified and documented here that will be enhanced over time.

1. Fork Hyperledger Bevel via Github UI.
2. Clone the fork to your local machine.
3. Complete the desired changes and where possible test locally:
     - Go to `platforms/shared/configuration` directory
     - Execute `molecule test --all`
     - Go to your changed platform directory like `platforms/r3-corda/configuration` (use respective platform directories)
     - Execute `molecule test --all`
4. Commit your changes         
     - Make sure you sign your commit using git commit -s for more information see [here](https://gist.github.com/tkuhrt/10211ae0a26a91a8c030d00344f7d11b).
     - Squash all commits to a single commit.
     - Make sure your commit message follows [Conventional Commits syntax](https://www.conventionalcommits.org/en/v1.0.0-beta.4/#specification) and contains the platform changed:
          - `[corda]` for Corda Opensource changes
          - `[corda-ent]` for Corda Enterprise changes
          - `[fabric]` for Hyperledger Fabric changes
          - `[besu]` for Hyperledger Besu changes
          - `[indy]` for Hyperledger Indy changes
          - `[quorum]` for Quorum changes
          - `[shared]` for all common and other changes
5. Push your changes to your feature branch.
6. Initiate a pull request from your fork to the base repository ( `develop` branch , unless it is a critical bug, in that case initiate to the `main` branch)
7. Await DCO & linting quality checks and GitActions to complete, as well as any feedback from reviewers.
8. Work on the feedbacks to revise the PR if there are any comments
9. If not, the PR gets approved , delete feature branch post the merge

---
**NOTE:** If you are a regular contributor , please make sure to take the latest pull from the develop branch everytime before making any pull request , main branch in case of a critical defect / bug .

---

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
