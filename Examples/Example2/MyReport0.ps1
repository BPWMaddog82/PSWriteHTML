
Import-Module PSWriteHTML -Force

$Time = Start-TimeLog

$ReportTitle = 'Test'

$ReportName = 'MyReport0'
$ReportPath = $PSScriptRoot

$DomainAdminTable = Get-ADForest | Select-Object ForestMode, Name, RootDomain, SchemaMaster
$EnterpriseAdminTable = Get-ADuser -Filter * | Select-Object Name, Surname, Enabled, DisplayName
$Allusers = Get-AdUser -Filter *

$Report = New-GenericList

$TabNames = 'Dashboard', 'Something'

$Report.Add($(Get-HTMLPage -Open -TitleText $ReportTitle -HideLogos -Verbose -AddAuthor -HideDate -UseCssLinks -UseStyleLinks)) #-LeftLogoString $CompanyLogo -RightLogoString $RightLogo -Verbose
$Report.Add($(Get-HTMLTabHeader -TabNames $TabNames))
$Report.Add($(Get-HTMLTab -Open -TabName 'Dashboard'))
$Report.Add($(Get-HTMLContent -Open -HeaderText "Groups"))
$Report.Add($(Get-HTMLContent -Open -BackgroundShade 1 -HeaderText 'Domain Administrators' -CanCollapse ))
$Report.Add($(Get-HTMLContentDataTable $DomainAdminTable -HideFooter))
$Report.Add($(Get-HTMLContent -Close))
$Report.Add($(Get-HTMLContent -Close))
$Report.Add($(Get-HTMLColumn -Close))

$Report.Add($(Get-HTMLContent -Open -HeaderText 'Enterprise Administrators' -CanCollapse -BackgroundShade 5) )
$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 1 -ColumnCount 2))
$Report.Add($(Get-HTMLContentDataTable $EnterpriseAdminTable -HideFooter))
$Report.Add($(Get-HTMLColumn -Close))
$Report.Add($(Get-HTMLContent -Close))

$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 2 -ColumnCount 2))
$Report.Add($(Get-HTMLContent -Open -HeaderText 'Enterprise Administrators') )
$Report.Add($(Get-HTMLContentDataTable $EnterpriseAdminTable -HideFooter))
$Report.Add($(Get-HTMLContent -Close))
$Report.Add($(Get-HTMLColumn -Close))


$Report.Add($(Get-HTMLContent -Open -HeaderText "Groups 1"))

$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 1 -ColumnCount 1))
$Report.Add($(Get-HTMLContentDataTable $DomainAdminTable -HideFooter))
$Report.Add($(Get-HTMLColumn -Close))

$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 1 -ColumnCount 1))
$Report.Add($(Get-HTMLContentDataTable $DomainAdminTable -HideFooter))
$Report.Add($(Get-HTMLColumn -Close))

$Report.Add($(Get-HTMLContent -Close))

$Report.Add($(Get-HTMLContent -Open -HeaderText "Groups 2"))

$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 1 -ColumnCount 1))
$Report.Add($(Get-HTMLContentDataTable $Allusers -HideFooter))
$Report.Add($(Get-HTMLColumn -Close))

$Report.Add($(Get-HTMLContent -Close))


$Report.Add($(Get-HTMLContent -Open -HeaderText "Groups 3"))

$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 1 -ColumnCount 4))
$Report.Add($(Get-HTMLContentDataTable $Allusers -HideFooter))
$Report.Add($(Get-HTMLColumn -Close))

$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 2 -ColumnCount 4))
$Report.Add($(Get-HTMLContentDataTable $Allusers -HideFooter))
$Report.Add($(Get-HTMLColumn -Close))

$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 3 -ColumnCount 4))
$Report.Add($(Get-HTMLContentDataTable $Allusers -HideFooter))
$Report.Add($(Get-HTMLColumn -Close))

$Report.Add($(Get-HTMLColumn -Open -ColumnNumber 4 -ColumnCount 4))
$Report.Add($(Get-HTMLContentDataTable $Allusers -HideFooter))
$Report.Add($(Get-HTMLColumn -Close))

$Report.Add($(Get-HTMLContent -Close))

$Report.Add($(Get-HTMLTab -Close))
$Report.Add($(Get-HTMLPage -Close))

Save-HTMLReport -ReportContent $Report -ReportName $ReportName -ReportPath $ReportPath -ShowReport


Stop-TimeLog -Time $Time -Option OneLiner