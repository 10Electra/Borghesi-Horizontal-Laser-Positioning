# Borghesi-Horizontal-Laser-Positioning

![3D-Graph-Example](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Borghesi%20Example%203D%20Graph%202.png?raw=true)

A MATLAB project to assist in the Borghesi-1022 experiment with aiming the laser at the least warped section of each target foil.
## Installation

Either:
 - Clone this repository into a local directory

or
 - Download the .zip file and open it locally
![ZIP Instructions](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/ZIP%20Instructions.png?raw=true)

## Usage

- Run the ``` main.m``` script
- Edit the following variables to fit the current data
  - ```filePath```
  - ```fileName```
  - ```left_foil_bound```, the location of the left edge of the foil (in data rows) on the x-axis
  - ```right_foil_bound```, the location of the right edge of the foil (in data rows) on the x-axis
  - ```approx_beam_width_um```

In the __Finding the least warped section of the foil__ section (around line 65), you can replace the _warp indicator_ ```r(i+k)``` with another of your choice. The _warp indicator_ array that is indexed here is calculated earlier in the script (around line 46).

The ```filePath``` depends on where you store the repository locally. The ```left_foil_bound``` and ```right_foil_bound``` have to be calculated and entered manually as the ends of the foil are sometimes vague or subjective.

Various metrics such as dimensions, material, and surface roughness can be found in the ___Array Target Characterisation.xlsx___ spreadsheet. Each row corresponds to a different target.

## A More Detailed Explanation
![3D Graph Example](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Borghesi%20Example%203D%20Graph%20Annotated.png?raw=true)

The algorithm tries to find the least warped section of the foil. It looks only at the middle third of the foil (marked with blue vertical lines in the diagram) whose bounds are calculated from the user-supplied end locations of the foil.

The algorithm's output is the location of the centre of a certain section of the foil that ```n``` data columns wide (```approx_beam_width_um``` microns wide).

This 'certain section' of foil was chosen as it either maximises or minimises the chosen _warp indicator(s)_, measured for each data column (or array slice) in the section and averaged.

### Simple Warp Indicators

The 'warp indicator' could be either:
 - the gradient of the best fit line in the ```y```-axis
 - the range (max - min) of the array slice's values

### Complex Warp Indicator

Recently, it was observed that the angle of the target wheel is able to be adjusted, so we can search for relative flatness, as opposed to absolute angle flatness (e.g. $\theta=0°$ or $m=0$).

This relative flatness can be approximated by the coefficient of determination ($R^2$ value) of the array slice's best fit line.

The only issue with this approach is that the algorithm will not take into account any flat twist (like any section of a Möbius strip). If the approx beam width is not thin, (```n > 1```) this flat twist will be problematic and should be minimised.

An indicator of the flat twist of the foil in a certain section is the standard deviation or variance of the array slices in that section.

The relative flatness and flat twist indicators can be combined in a weighted sum to form a new warp indicator.

The ___dev___ branch contains an implementation of the relative flatness _warp indicator_. Instead of using a flat twist indicator, the current implementation on ___dev___ plots a graph of all of the slices in the chosen least warped section so the user can check for flat twist.

## Bugfixes

A bug involving scaling problems for height data between Vision64 and MATLAB has recently been fixed. Originally, the height data MATLAB loaded from the .OPD files was both differently scaled and vertically translated. This issue has been fixed so the data is now correctly scaled automatically. _The vertical scale in MATLAB is in microns_.

| ![Vision64](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/1C3%20Vision64%20example.png?raw=true)| ![MATLAB](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/1C3%20MATLAB%20example.png?raw=true)|
|-----|--------|
|Vision64 scan |MATLAB surface|

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
