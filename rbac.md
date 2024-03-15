# RBAC

These are the roles and what that roles can do mapping- should be present in casbin_rule table prior to invoke any endpoint

---

## | ptype | v0 | v1 |

| g2 | profile.read | basic |
| g2 | org.read | basic |
| g2 | dir.read | basic |
| g2 | workspace.read | basic |
| g2 | _.read | viewer |
| g2 | viewer | editor |
| g2 | _.update | editor |
| g2 | editor | admin |
| g2 | _.create | admin |
| g2 | _.delete | admin |
| g2 | _. _ | owner |

---

User/Group resource Policies - for any onboarded organization, need to create a 4 policy(roles to access resources for created organization, it could be organization level and for any workspace created, need to create 4 policy(roles to access resources for workspace)

API endpoint is /role_access_mapper/<string:group/link/<role>/link/<organization_id>?workspace_id=$workspace_id (workspace_id not mandatory)

endpoint will create a policy in system as below

              --------------------------------------------------------------------------------------------------------------------------------------------

## Table columns : ptype | v0 | v1 | v2 |

## Values : p | xyz_admin | /org/2/\* | admin (whoever have xyz_admin role will have admin role inside org=2) |

               ------------------------------------------------------------------------------------------------------------------------------------------

## Table columns : ptype | v0 | v1 | v2 |

## Values : p | xyz_2_admin | /org/2/workspace/4/\* | admin (whoever have xyz_2_admin role will have admin role inside org=2 and workspace=4) |

There will be another endpoint which will assign role to users

Endpoint /role_access_mapper/{user}/link/{role}
endpoint will create a user-role mapping in system as below

---

g | user1@example_google_domain.com | xyz_admin |
g | user2@example_google_domain.com | xyz_2_admin |

---

Below are some scenario

Create Org = 2, name=xyz

Create Org = 3, name=abc

Create Workspace=2 under org=2

Create Workspace=3 under org=2

Create Policy like

## org level

Ptype=p, V0= xyz_viewer /org/2/\* viewer

Ptype=p, V0= xyz_editor /org/2/\* editor

Ptype=p, V0= xyz_admin /org/2/\* admin workspace level

Ptype=p, V0= xyz_2_viewer /org/2/workspace/2/\* viewer

Ptype=p, V0= xyz_2_editor /org/2/workspace/2/\* editor

Ptype=p, V0= xyz_2_admin /org/2/workspace/2/\* admin

##############Test Scenario workspace level#######################

Assign user to a role - xyz_2_viewer(Workspace level)

Get folder in org 2 and workspace 2 - pass

Get workspace in org 2 and workspace 3 - fail

Create Workspace under org 2 - fail

Create Workspace under org 3 - fail

Update workspace under org 2 - fail
Update workspace under org 3 - fail

---

## Assign user to a role - xyz_2_editor(Workspace level)

Get workspace in org 2 and workspace 2 - pass

Get workspace in org 2 and workspace 3 - fail

Get workspace in org 3 - fail

Create Workspace under org 2 - fail

Create Workspace under org 3 - fail

Update workspace 2 under org 2 - pass

Update workspace 3 under org 3 - fail

---

## Assign user to a role - xyz_2_admin(Workspace level)

Get workspace in org 2 and workspace 2 - fail
Get workspace in org 2 and workspace 3 - fail

Get workspace in org 3 - fail
Create Workspace under org 2 - fail

Create Workspace under org 3 - fail

Update workspace 2 under org 2 - pass

Update workspace 3 under org 3 - fail

Create Folder under org 2, workspace 2 - pass

Create Folder under org 2, workspace 3 - fail

#####################Test Scenario org level###################

Assign user to a role - xyz_viewer(org level)

Get workspace in org 2 - pass

Get workspace in org 3 - fail

Create Workspace under org 2 - fail

Create Workspace under org 3 - fail

Update workspace under org 2 - fail

Update workspace under org 3 - fail

---

Assign user to a role - xyz_editor(org level)

Get workspace in org 2 - pass

Get workspace in org 3 - fail

Create Workspace under org 2 - fail

Create Workspace under org 3 - fail

Update workspace under org 2 - pass

Update workspace under org 3 - fail

---

Assign user to a role - xyz_admin(org level)

Get workspace in org 2 - pass

Get workspace in org 3 - fail

Create Workspace under org 2 - pass

Create Workspace under org 3 - fail

Update workspace under org 2 - pass

Update workspace under org 3 - fail
