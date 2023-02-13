# Borghesi-Horizontal-Laser-Positioning
A MATLAB project to assist the Borghesi-1022 experiment by finding the least warped section of each foil in each Borghesi microtarget array.

The foils are individually scanned using a white light interferometer normal to the foil. The foil's height map is then saved in the .OPD file format and uploaded to the ___Characterisation Data___ directory of this repository. The file's name, path and approximate foil position can be given to the _main.m_ script, which then uses an algorithm (explained below) to determine the least warped section. A plot of the foil's 3D surface that includes the relevant result annotations can be shown.

## Installation

Either:
 - Clone this repository into a local directory

or
 - Download the .zip file and open it locally

<figure>
<img
  src="https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/ZIP%20Instructions%20cropped.png?raw=true"
  alt=".zip instructions"
  style="display: block; 
          margin-left: 0px;
          margin-right: auto;
          width: 300px;">
<figcaption align = "left"><b>.zip instructions</b></figcaption>
</figure>

## Usage

- Run the ` main.m` script
- Edit the following variables to fit the current data
  - `filePath`
  - `fileName`
  - `left_foil_bound`, the location of the left edge of the foil (in data rows) on the x-axis
  - `right_foil_bound`, the location of the right edge of the foil (in data rows) on the x-axis
  - `approx_beam_width_um`

In the __Finding the least warped section of the foil__ section (around line 65), you can replace the _warp indicator_ `r(i+k)` with another of your choice. The _warp indicator_ array that is indexed here is calculated earlier in the script (around line 46).

The `filePath` depends on where you store the repository locally. The `left_foil_bound` and `right_foil_bound` have to be calculated and entered manually as the ends of the foil are sometimes vague or subjective.

<figure>
<img
  src="https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Borghesi%20Mount%20Diagram.png?raw=true"
  alt="Naming Convention"
  style="display: block; 
          margin-left: auto;
          margin-right: auto;
          width: 400px;">
<figcaption align = "center"><b>Naming convention of foil data files</b></figcaption>
</figure>


Various metrics such as dimensions, material, and surface roughness can be found in the ___Array Target Characterisation.xlsx___ spreadsheet. Each row corresponds to a different target.

## A More Detailed Explanation
![3D Graph Example](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Borghesi%20Example%203D%20Graph%20Annotated.png?raw=true)

The algorithm tries to find the least warped section of the foil. It looks only at the middle third of the foil (marked with blue vertical lines in the diagram) whose bounds are calculated from the user-supplied end locations of the foil.

The algorithm's output is the location of the centre of a certain section of the foil that `n` data columns wide (`approx_beam_width_um` microns wide).

This 'certain section' of foil was chosen as it either maximises or minimises the chosen _warp indicator(s)_, measured for each data column (or array slice) in the section and averaged.

### Simple Warp Indicators

The 'warp indicator' could be either:
 - the gradient of the best fit line in the `y`-axis
 - the range (max - min) of the array slice's values

### Complex Warp Indicator

Recently, it was observed that the angle of the target wheel is able to be adjusted, so we can search for relative flatness, as opposed to absolute angle flatness (e.g. $\theta=0°$ or $m=0$).

This relative flatness can be approximated by the coefficient of determination ($R^2$ value) of the array slice's best fit line.

The only issue with this approach is that the algorithm will not take into account any flat twist (like any section of a Möbius strip). If the approx beam width is not thin, (`n > 1`) this flat twist will be problematic and should be minimised.

An indicator of the flat twist of the foil in a certain section is the standard deviation or variance of the array slices in that section.

The relative flatness and flat twist indicators can be combined in a weighted sum to form a new warp indicator.

The ___dev___ branch contains an implementation of the relative flatness _warp indicator_. Instead of using a flat twist indicator, the current implementation on ___dev___ plots a graph of all of the slices in the chosen least warped section so the user can check for flat twist.

## Bugfixes

A bug involving scaling problems for height data between Vision64 and MATLAB has recently been fixed. Originally, the height data MATLAB loaded from the .OPD files was both differently scaled and vertically translated. This issue has been fixed so the data is now correctly scaled automatically. _The vertical scale in MATLAB is in microns_.

| ![Vision64](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/1C3%20Vision64%20scan%20example.png?raw=true) | ![MATLAB](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/1C3%20MATLAB%20example.png?raw=true) |
|-|-|
| Vision64 scan | MATLAB surface|

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
