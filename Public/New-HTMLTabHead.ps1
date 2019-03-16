<#
Function New-HTMLTabHead {
    [CmdletBinding()]
    Param (
        
    )
    
    New-HTMLTag -Tag 'div' -Attributes @{ class = '' } {
        New-HTMLTag -Tag 'ul' -Attributes @{ class = 'tab-nav'} {
            foreach ($Tab in $Script:HTMLSchema.TabsHeaders) {
                New-HTMLTag -Tag 'li' {
                    if ($Tab.Active) {
                        New-HTMLAnchor -Class 'buttonTab active' -HrefLink "#$($Tab.Id)" -Text $Tab.Name
                    } else {
                        New-HTMLAnchor -Class 'buttonTab' -HrefLink "#$($Tab.Id)" -Text $Tab.Name
                    }
                }
            }
        }
    }
}

#>
Function New-HTMLTabHead {
    [CmdletBinding()]
    Param (
        
    )
    
    New-HTMLTag -Tag 'div' -Attributes @{ class = 'tabsWrapper' } {
        New-HTMLTag -Tag 'div' -Attributes @{ class = 'tabs' } {
            New-HTMLTag -Tag 'div' -Attributes @{ class = 'selector' }
            foreach ($Tab in $Script:HTMLSchema.TabsHeaders) {
           
                if ($Tab.Active) {
                    $AttributesA = @{
                        'class'   = 'active'
                        'href'    = 'javascript:void(0)'
                        'data-id' = "$($Tab.Id)"
                    }

                    New-HTMLTag -Tag 'a' -Attributes $AttributesA {
                        New-HTMLTag -Tag 'i' -Attributes @{ class = 'fas fa-bomb' } -Value { $Tab.Name }
                    }
                    #New-HTMLAnchor -Class 'active' -HrefLink "#$($Tab.Id)" -Text $Tab.Name
                } else {
                    # New-HTMLAnchor -Class '' -HrefLink "#" -Text $Tab.Name

                    $AttributesA = @{
                        'class'   = ''
                        'href'    = 'javascript:void(0)'
                        'data-id' = "$($Tab.Id)"
                    }

                    New-HTMLTag -Tag 'a' -Attributes $AttributesA {
                        New-HTMLTag -Tag 'i' -Attributes @{ class = 'fas fa-bomb' } -Value { $Tab.Name }
                    }
                }
            }
            
        }
    }
}