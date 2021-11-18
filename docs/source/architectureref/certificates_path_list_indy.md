[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Certificate Paths on Vault for Indy Network
---------------------------------------------

### For each organization

| Path                | Key (for Vault)                        | Type             |
|-----------------------------------|--------------------------|------------------|
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/identity/private/            | seed                | String           |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/identity/public/             | did                 | String           |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/private/private_keys/   | `identity_name_lowercase`.key_secret    | Private Key      |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/private/bls_keys/       | bls_sk                                 | Secret Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/private/sig_keys/       | `identity_name_lowercase`.key_secret    | Private Key      |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/public/public_keys/     | public-key                             | Public Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/public/public_keys/     | `identity_name_lowercase`.key           | Public Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/public/bls_keys/        | bls_pk                                 | Public Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/public/bls_keys/        | bls-public-key                         | Public Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/public/bls_keys/        | bls-key-pop                            | Public Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/public/verif_keys/      | `identity_name_lowercase`.key           | Public Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/node/public/verif_keys/      | verification-key                       | Verification Key |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/client/private/private_keys/ | `identity_name_lowercase`-1C.key_secret | Private Key      |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/client/private/sig_keys/     | `identity_name_lowercase`-1C.key_secret | Private Key      |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/client/public/public_keys/   | public-key                             | Public Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/client/public/public_keys/   | `identity_name_lowercase`-1C.key        | Public Key       |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/client/public/verif_keys/    | `identity_name_lowercase`-1C.key        | Public Key |
| /`org_name_lowercase`/role (trustees / stewards / endorsers)/`identity_name_lowercase`/client/public/verif_keys/    | verification-key                       | Verification Key |
