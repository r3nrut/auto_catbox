$Group = "*"
$adDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$WootRoot = $adDomain.GetDirectoryEntry()
$adoConnection = New-Object -comObject "ADODB.Connection"
$adoCommand = New-Object -comObject "ADODB.Command"
$adoConnection.Open("Provider=ADsDSOObject;")
$adoCommand.ActiveConnection = $adoConnection
$adoCommand.Properties.Item("Page Size") = 999
$adoCommand.Properties.Item("Cache Results") = $False

$BassDrop = $WootRoot.distinguishedName
$Scope = "subtree"
$Filter = "(&(objectCategory=group)(sAMAccountName=$Group))"

$Last = $False
$RStep = 999
$LRange = 0
$HRange = $LRange + $RStep
$Total = 0
$ExitFlag = $False

Do
{
    If ($Last -eq $True)
    {
        $Attributes = "member;range=$LRange-*"
    }
    Else
    {
        $Attributes = "member;range=$LRange-$HRange"
    }
    $Query = "<LDAP://$BassDrop>;$Filter;$Attributes;$Scope"

    $adoCommand.CommandText = $Query
    $adoRecordset = $adoCommand.Execute()
    $Count = 0

    $Members = $adoRecordset.Fields.Item("$Attributes").Value
    If ($Members -eq $Null)
    {
        "Group $Group not found"
        $Last = $True
    }
    Else
    {
        If ($Members.GetType().Name -eq "Object[]")
        {
            ForEach ($Member In $Members)
            {
                $Member
                $Count = $Count + 1
            }
        }
    }
    $adoRecordset.Close()
    $Total = $Total + $Count

    If ($Last -eq $True) {$ExitFlag = $True}
    Else
    {
        If ($Count -eq 0) {$Last = $True}
        Else
        {
            $LRange = $HRange + 1
            $HRange = $LRange + $RStep
        }
    }
} Until ($ExitFlag -eq $True)

$adoConnection.Close()
"$Total"