﻿function New-HTMLChart {
    [alias('Chart')]
    [CmdletBinding()]
    param(
        [ScriptBlock] $ChartSettings,
        [string] $Title,
        [ValidateSet('center', 'left', 'right', 'default')][string] $TitleAlignment = 'default',
        [nullable[int]] $Height = 350,
        [nullable[int]] $Width,
        [alias('GradientColors')][switch] $Gradient,
        [alias('PatternedColors')][switch] $Patterned
    )
    $Script:HTMLSchema.Features.MainFlex = $true
    # Datasets Bar/Line
    $DataSet = [System.Collections.Generic.List[object]]::new()
    $DataName = [System.Collections.Generic.List[object]]::new()

    $DataSetChartTimeLine = [System.Collections.Generic.List[PSCustomObject]]::new()

    # Legend Variables
    $Colors = [System.Collections.Generic.List[string]]::new()

    # Line Variables
    # $LineColors = [System.Collections.Generic.List[string]]::new()
    $LineCurves = [System.Collections.Generic.List[string]]::new()
    $LineWidths = [System.Collections.Generic.List[int]]::new()
    $LineDashes = [System.Collections.Generic.List[int]]::new()
    $LineCaps = [System.Collections.Generic.List[string]]::new()

    #$RadialColors = [System.Collections.Generic.List[string]]::new()
    #$SparkColors = [System.Collections.Generic.List[string]]::new()

    # Bar default definitions
    [bool] $BarHorizontal = $true
    [bool] $BarDataLabelsEnabled = $true
    [int] $BarDataLabelsOffsetX = -6
    [string] $BarDataLabelsFontSize = '12px'
    [bool] $BarDistributed = $false

    [string] $Type = ''

    [Array] $Settings = & $ChartSettings
    foreach ($Setting in $Settings) {
        if ($Setting.ObjectType -eq 'Bar') {
            # For Bar Charts
            if (-not $Type) {
                # this makes sure type is not set if BarOptions is used which already set type to BarStacked or similar
                $Type = $Setting.ObjectType
            }
            $DataSet.Add($Setting.Value)
            $DataName.Add($Setting.Name)

        } elseif ($Setting.ObjectType -eq 'Pie' -or $Setting.ObjectType -eq 'Donut') {
            # For Pie Charts
            $Type = $Setting.ObjectType
            $DataSet.Add($Setting.Value)
            $DataName.Add($Setting.Name)

            if ($Setting.Color) {
                $Colors.Add($Setting.Color)
            }
        } elseif ($Setting.ObjectType -eq 'Spark') {
            # For Spark Charts
            $Type = $Setting.ObjectType
            $DataSet.Add($Setting.Value)
            $DataName.Add($Setting.Name)

            if ($Setting.Color) {
                $Colors.Add($Setting.Color)
            }
        } elseif ($Setting.ObjectType -eq 'Radial') {
            $Type = $Setting.ObjectType
            $DataSet.Add($Setting.Value)
            $DataName.Add($Setting.Name)

            if ($Setting.Color) {
                $Colors.Add($Setting.Color)
            }
        } elseif ($Setting.ObjectType -eq 'Legend') {
            # For Bar Charts
            $DataLegend = $Setting.Names
            if ($null -ne $Setting.Color) {
                $Colors = $Setting.Color
            }
            $Legend = $Setting.Legend
        } elseif ($Setting.ObjectType -eq 'BarOptions') {
            # For Bar Charts
            $Type = $Setting.Type
            $BarHorizontal = $Setting.Horizontal
            $BarDataLabelsEnabled = $Setting.DataLabelsEnabled
            $BarDataLabelsOffsetX = $Setting.DataLabelsOffsetX
            $BarDataLabelsFontSize = $Setting.DataLabelsFontSize
            $BarDataLabelsColor = $Setting.DataLabelsColor
            $BarDistributed = $Setting.Distributed

            # This is required to support legacy ChartBarOptions - Gradient -Patterned
            if ($null -ne $Setting.PatternedColors) {
                $Patterned = $Setting.PatternedColors
            }
            if ($null -ne $Setting.GradientColors) {
                $Gradient = $Setting.GradientColors
            }
        } elseif ($Setting.ObjectType -eq 'Toolbar') {
            # For All Charts
            $Toolbar = $Setting.Toolbar
        } elseif ($Setting.ObjectType -eq 'Theme') {
            # For All Charts
            $Theme = $Setting.Theme
        } elseif ($Setting.ObjectType -eq 'Line') {
            # For Line Charts
            $Type = $Setting.ObjectType
            $DataSet.Add($Setting.Value)
            $DataName.Add($Setting.Name)
            if ($Setting.LineColor) {
                $Colors.Add($Setting.LineColor)
            }
            if ($Setting.LineCurve) {
                $LineCurves.Add($Setting.LineCurve)
            }
            if ($Setting.LineWidth) {
                $LineWidths.Add($Setting.LineWidth)
            }
            if ($Setting.LineDash) {
                $LineDashes.Add($Setting.LineDash)
            }
            if ($Setting.LineCap) {
                $LineCaps.Add($Setting.LineCap)
            }
        } elseif ($Setting.ObjectType -eq 'ChartAxisX') {
            $ChartAxisX = $Setting.ChartAxisX
        } elseif ($Setting.ObjectType -eq 'ChartGrid') {
            $GridOptions = $Setting.Grid
        } elseif ($Setting.ObjectType -eq 'ChartAxisY') {
            $ChartAxisY = $Setting.ChartAxisY
        } elseif ($Setting.ObjectType -eq 'TimeLine') {
            $Type = 'rangeBar'
            $DataSetChartTimeLine.Add($Setting.TimeLine)
        } elseif ($Setting.ObjectType -eq 'ChartToolTip') {
            $ChartToolTip = $Setting.ChartToolTip
        } elseif ($Setting.ObjectType -eq 'DataLabel') {
            $DataLabel = $Setting.DataLabel
        } elseif ($Setting.ObjectType -eq 'ChartEvents') {
            $Events = $Setting.Event
        }
    }

    if ($Type -in @('bar', 'barStacked', 'barStacked100Percent')) {
        #if ($DataLegend.Count -lt $DataSet[0].Count) {
        #    Write-Warning -Message "Chart Legend count doesn't match values count. Skipping."
        #}
        # Fixes dataset/dataname to format expected by New-HTMLChartBar
        $HashTable = [ordered] @{ }
        $ArrayCount = $DataSet[0].Count
        if ($ArrayCount -eq 1) {
            $HashTable.1 = $DataSet
        } else {
            for ($i = 0; $i -lt $ArrayCount; $i++) {
                $HashTable.$i = [System.Collections.Generic.List[object]]::new()
            }
            foreach ($Value in $DataSet) {
                for ($h = 0; $h -lt $Value.Count; $h++) {
                    $HashTable[$h].Add($Value[$h])
                }
            }
        }

        New-HTMLChartBar `
            -Data $($HashTable.Values) `
            -DataNames $DataName `
            -DataLegend $DataLegend `
            -Legend $Legend `
            -Type $Type `
            -Title $Title `
            -TitleAlignment $TitleAlignment `
            -Horizontal:$BarHorizontal `
            -DataLabelsEnabled $BarDataLabelsEnabled `
            -DataLabelsOffsetX $BarDataLabelsOffsetX `
            -DataLabelsFontSize $BarDataLabelsFontSize `
            -Distributed:$BarDistributed `
            -DataLabelsColor $BarDataLabelsColor `
            -Height $Height `
            -Width $Width `
            -Colors $Colors `
            -ChartAxisX $ChartAxisX `
            -ChartAxisY $ChartAxisY `
            -Theme $Theme -Toolbar $Toolbar -GridOptions $GridOptions -PatternedColors:$Patterned -GradientColors:$Gradient -Events $Events
    } elseif ($Type -eq 'Line') {
        if (-not $ChartAxisX) {
            Write-Warning -Message 'Chart Category (Chart Axis X) is missing.'
            return
        }
        New-HTMLChartLine -Data $DataSet `
            -Legend $Legend `
            -DataNames $DataName `
            -DataLabelsEnabled $BarDataLabelsEnabled `
            -DataLabelsOffsetX $BarDataLabelsOffsetX `
            -DataLabelsFontSize $BarDataLabelsFontSize `
            -DataLabelsColor $BarDataLabelsColor `
            -LineColor $Colors `
            -LineCurve $LineCurves `
            -LineWidth $LineWidths `
            -LineDash $LineDashes `
            -LineCap $LineCaps `
            -ChartAxisX $ChartAxisX `
            -ChartAxisY $ChartAxisY `
            -Title $Title -TitleAlignment $TitleAlignment `
            -Height $Height -Width $Width `
            -Theme $Theme -Toolbar $Toolbar -GridOptions $GridOptions -PatternedColors:$Patterned -GradientColors:$Gradient -Events $Events

    } elseif ($Type -eq 'Pie' -or $Type -eq 'Donut') {
        New-HTMLChartPie `
            -Legend $Legend `
            -Type $Type `
            -Data $DataSet `
            -DataNames $DataName `
            -Colors $Colors `
            -Title $Title -TitleAlignment $TitleAlignment `
            -Height $Height -Width $Width `
            -Theme $Theme -Toolbar $Toolbar -GridOptions $GridOptions -PatternedColors:$Patterned -GradientColors:$Gradient -Events $Events
    } elseif ($Type -eq 'Spark') {
        New-HTMLChartSpark `
            -Legend $Legend `
            -Data $DataSet `
            -DataNames $DataName `
            -Colors $Colors `
            -Title $Title -TitleAlignment $TitleAlignment `
            -Height $Height -Width $Width `
            -Theme $Theme -Toolbar $Toolbar -GridOptions $GridOptions -PatternedColors:$Patterned -GradientColors:$Gradient -Events $Events
    } elseif ($Type -eq 'Radial') {
        New-HTMLChartRadial `
            -Legend $Legend `
            -Data $DataSet `
            -DataNames $DataName `
            -Colors $Colors `
            -Title $Title -TitleAlignment $TitleAlignment `
            -Height $Height -Width $Width `
            -Theme $Theme -Toolbar $Toolbar -GridOptions $GridOptions -PatternedColors:$Patterned -GradientColors:$Gradient -Events $Events
    } elseif ($Type -eq 'rangeBar') {
        New-HTMLChartTimeLine `
            -Legend $Legend `
            -Data $DataSetChartTimeLine `
            -Title $Title `
            -TitleAlignment $TitleAlignment `
            -Height $Height -Width $Width `
            -Theme $Theme -Toolbar $Toolbar `
            -ChartAxisX $ChartAxisX `
            -ChartAxisY $ChartAxisY `
            -ChartToolTip $ChartToolTip `
            -GridOptions $GridOptions -PatternedColors:$Patterned -GradientColors:$Gradient `
            -DataLabel $DataLabel -Events $Events
    }
}