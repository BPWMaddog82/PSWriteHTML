﻿function New-HTMLNavFloat {
    [cmdletBinding()]
    param(
        [ScriptBlock] $NavigationLinks,
        [string] $Title,
        [alias('SubTitle')][string] $Tagline,
        [string] $TitleColor,
        [string] $TaglineColor,
        [object] $ButtonLocationTop,
        [object] $ButtonLocationLeft,
        [object] $ButtonLocationRight,
        [object] $ButtonLocationBottom,
        [string] $ButtonColor,
        [string] $ButtonColorBackground,
        [string] $ButtonBackgroundColorOnHover
    )

    $Script:HTMLSchema.Features.NavigationFloat = $true
    $Script:HTMLSchema.Features.JQuery = $true
    $Script:HTMLSchema.Features.FontsMaterialIcon = $true
    $Script:HTMLSchema.Features.FontsAwesome = $true

    # We also need to make sure we add this to all pages, not just the primary one
    $Script:GlobalSchema.Features.NavigationFloat = $true
    $Script:GlobalSchema.Features.JQuery = $true
    $Script:GlobalSchema.Features.FontsMaterialIcon = $true
    $Script:GlobalSchema.Features.FontsAwesome = $true

    #$Script:CurrentConfiguration['Features']['Main']['HeaderAlways']['CssInLine']['.main-section']['margin-top'] = '55px'
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-trigger']['top'] = $ButtonLocationTop
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-trigger']['left'] = $ButtonLocationLeft
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-trigger']['right'] = $ButtonLocationRight
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-trigger']['bottom'] = $ButtonLocationBottom
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-trigger']['background-color'] = ConvertFrom-Color -Color $ButtonColorBackground
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-trigger']['color'] = ConvertFrom-Color -Color $ButtonColor
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-trigger']['color'] = ConvertFrom-Color -Color $ButtonColor

    # title color
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-widget.top-header h2']['color'] = ConvertFrom-Color -Color $TitleColor
    # tagline color
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.top-header .tagline']['color'] = ConvertFrom-Color -Color $TaglineColor
    # trigger hover
    $Script:CurrentConfiguration['Features']['NavigationFloat']['HeaderAlways']['CssInLine']['.penal-trigger:hover']['color'] = ConvertFrom-Color -Color $ButtonBackgroundColorOnHover

    if ($LogoLinkHome) {
        $LogoLink = "$($Script:GlobalSchema.StorageInformation.FileName).html"
    }

    if ($NavigationLinks) {
        $Output = & $NavigationLinks
        $NavGridItems = [System.Collections.Generic.List[string]]::new()
        $NavLinks = [System.Collections.Generic.List[string]]::new()
        $NavGridMenu = [System.Collections.Generic.List[string]]::new()
        $TopMenu = [System.Collections.Generic.List[string]]::new()
        foreach ($Link in $Output) {
            if ($Link.Type -eq 'NavGridItem') {
                $NavGridItems.Add($Link.Value)
            } elseIf ($Link.Type -eq 'NavLinkItem') {
                $NavLinks.Add($Link.Value)
            } elseif ($Link.Type -eq 'NavGridMenu') {
                $NavGridMenu.Add($Link.Value)
            } elseif ($Link.Type -eq 'TopMenu') {
                $TopMenu.Add($Link.Value)
            }
        }
    }

    $Options = @{

    }
    $OptionsJSON = $Options | ConvertTo-Json

    # Header
    $Navigation = @(
        # button to open side penal
        New-HTMLTag -Tag 'button' -Attributes @{ class = 'penal-trigger' }

        New-HTMLTag -Tag 'section' -Attributes @{ class = 'side-penal' } {
            New-HTMLTag -Tag 'div' -Attributes @{class = 'penal-widget top-header' } {
                New-HTMLTag -Tag 'h2' {
                    $Title
                }
                New-HTMLTag -Tag 'i' -Attributes @{ class = 'tagline' } {
                    $Tagline
                }

                if ($Output) {
                    $Output
                }
                <#
                # 3 dots menu
                New-HTMLTag -Tag 'menu' -Attributes @{ class = 'top-links' } {
                    New-HTMLTag -Tag 'menuitem' { New-HTMLTag -Tag 'a' -Attributes @{ href = '#1' } { 'Menu 1' } }
                    New-HTMLTag -Tag 'menuitem' { New-HTMLTag -Tag 'a' -Attributes @{ href = '#1' } { 'Menu 2' } }
                    New-HTMLTag -Tag 'menuitem' { New-HTMLTag -Tag 'a' -Attributes @{ href = '#1' } { 'Menu 3' } }
                }
                # select box
                New-HTMLTag -Tag 'div' -Attributes @{ class = 'penal-widget' } {
                    New-HTMLTag -Tag 'h3' { 'Tezt' }
                    New-HTMLTag -Tag 'select' -Attributes @{ class = 'penal-select' } {
                        New-HTMLTag -Tag 'option' { 'Option 1' }
                        New-HTMLTag -Tag 'option' { 'Option 2' }
                        New-HTMLTag -Tag 'option' { 'Option 3' }
                    }
                }
                # list of options
                New-HTMLTag -Tag 'div' -Attributes @{ class = 'penal-widget' } {
                    New-HTMLTag -Tag 'h3' { 'Tezt' }
                    New-HTMLTag -Tag 'ul' -Attributes @{ class = "penal-list" } {
                        New-HTMLTag -Tag 'li' { New-HTMLTag -Tag 'a' -Attributes @{ href = '#1' } { 'List 1' } }
                        New-HTMLTag -Tag 'li' { New-HTMLTag -Tag 'a' -Attributes @{ href = '#1' } { 'List 2' } }
                    }
                }
                # switch widget options
                New-HTMLTag -Tag 'div' -Attributes @{ class = "penal-widget toggle-switch" } {
                    New-HTMLTag -Tag 'h3' { 'Toggle options' }
                    New-HTMLTag -Tag 'ul' -Attributes @{ class = "toggle-buttons" } {
                        New-HTMLTag -Tag 'li' { 'Switch 1' }
                        New-HTMLTag -Tag 'li' { 'Switch 1' }
                        New-HTMLTag -Tag 'li' { 'Switch 2' }
                    }
                }
                # list of options
                New-HTMLTag -Tag 'ul' -Attributes @{ class = "penal-list" } {
                    New-HTMLTag -Tag 'li' { New-HTMLTag -Tag 'a' -Attributes @{ href = '#1' } { 'List 1' } }
                    New-HTMLTag -Tag 'li' { New-HTMLTag -Tag 'a' -Attributes @{ href = '#1' } { 'List 2' } }
                }
                # About
                New-HTMLTag -Tag 'div' -Attributes @{ class = "penal-widget about" } {
                    New-HTMLTag -Tag 'h3' { 'About' }
                    New-HTMLText -Text 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
                }
                #>
            }
        }
    )

    [PSCustomObject] @{
        Type   = 'Navigation'
        Output = $Navigation
    }

}
Register-ArgumentCompleter -CommandName New-HTMLNavFloat -ParameterName ButtonColor -ScriptBlock $Script:ScriptBlockColors
Register-ArgumentCompleter -CommandName New-HTMLNavFloat -ParameterName ButtonColorBackground -ScriptBlock $Script:ScriptBlockColors
Register-ArgumentCompleter -CommandName New-HTMLNavFloat -ParameterName ButtonBackgroundColorOnHover -ScriptBlock $Script:ScriptBlockColors
Register-ArgumentCompleter -CommandName New-HTMLNavFloat -ParameterName TitleColor -ScriptBlock $Script:ScriptBlockColors
Register-ArgumentCompleter -CommandName New-HTMLNavFloat -ParameterName TaglineColor -ScriptBlock $Script:ScriptBlockColors