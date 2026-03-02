





CREATE VIEW [security].[vw_RoleDomainPermissions_TEST]
AS
SELECT
    pa.PermissionAssocId AS Id,
    --pa.ParentPermAssocId, -- removed 2026-02-02 unable to remember why this is here.  doesn't seem necessary in underlying table so should not be in view
    r.RoleId,
    r.RoleName,
    pa.ClaimTypeId,
    ct.ClaimTypeKey,
    ct.ClaimTypeName,
    d.DomainKey,
    d.DomainName,
    pa.FieldId,
    CASE WHEN pa.FieldId IS NOT NULL THEN f.FieldName END AS FieldName,
    pa.PermissionId,
    p.PermissionKey,
    p.PermissionName,
    CONCAT(
        d.DomainKey,
        ':',
        f.FieldName,
        CASE WHEN f.FieldName IS NULL THEN '' ELSE ':' END,
        p.PermissionKey
    ) AS RequiredClaimValue
    ,pa.IsOptionControlled
    ,lpa.PermissionAssocId
FROM security.PermissionAssoc pa
    JOIN security.RolePermissionsAssoc rpa ON pa.PermissionAssocId = rpa.PermissionAssocId
    left join 
    ( select ora.PermissionAssocId from security.OptionRightsAssoc ora 
        join Company.LocationOptionAssoc loa on ora.OptionId = loa.OptionId
    ) lpa on rpa.PermissionAssocId = lpa.PermissionAssocId
    JOIN security.Roles r ON rpa.RoleId = r.RoleId
    JOIN security.Domain d ON pa.DomainId = d.DomainId
    JOIN security.Permission p ON pa.PermissionId = p.PermissionId
    JOIN security.ClaimType ct ON pa.ClaimTypeId = ct.ClaimTypeId
    LEFT JOIN security.Field f ON pa.FieldId = f.FieldId
where pa.IsOptionControlled = 0 or lpa.PermissionAssocId is not null