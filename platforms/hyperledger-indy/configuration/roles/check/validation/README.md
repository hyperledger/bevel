[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## check/validation
This role checks for validation of network.yaml

## Tasks:
### 1. Check Validation
Runs subtasks to validation of network.yaml
##### Variables:
 - organizationItem: An organization item from network.yaml file.
 - network: A variable represents content of network.yaml file.
##### Input Variables:
 - trustees: A list of trustees service of current organization.
 - endorsers: A list of endorsers service of current organization.
 - stewards: A list of stewards service of current organization.

#### 1.1 Counting Genesis Steward
Counts number of stewards defined in network.yaml file.
##### Input Variables:
 - steward_count: A count of stewards.
##### Output Variables:
 - steward_count: A count of stewards.

#### 1.2 Set trustee count to zero
Resets counter of trustees to zero.
##### Input Variables:
 - trustee_count: A count of trustees.

#### 1.3 Counting trustees per Org
Counts number of trustees in current organization and also counts number of truetees in all organization.
##### Input Variables:
 - trustee_count: A count of trustees in current organization.
 - total_trustees: A count of trustees in all organizations.
##### Output Variables:
 - trustee_count: A count of trustees in current organization.
 - total_trustees: A count of trustees in all organizations.

#### 1.4 Print error and end playbook if trustee count limit fails
Prints an error, when exits more then one trustee per organization.
##### Input Variables:
 - trustee_count: A count of trustees in current organization.

#### 1.5 Counting  Endorsers
Counts number of endorsers of current organization.
##### Input Variables:
 - endorser_count: A count of endorsers in current organization.
##### Output Variables:
 - endorser_count: A count of endorsers in current organization. 

#### 1.6 Print error abd end playbook  if endorser count limit fails
Prints an error, when exits more then one endorser per organization.
##### Input Variables:
 - endorser_count: A count of endorsers in current organization.

#### 1.7 Reset Endorser count
Resets counter of trustees to zero.
##### Input Variables:
 - trustee_count: A count of trustees.

---
### 2. Print error and end playbook if genesis steward count limit fails
Prints an error, when count of stewards in all organizations is less then 4.
#### Input Variables:
 - steward_count: A count of stewards of all organizations.

---
### 3. Print error and end playbook if total trustee count limit fails
Prints an error, when count of trustess in all organization is less then one.
#### Input Variables:
 - total_trustees: A count of trustees of all organizations.