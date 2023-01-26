# Borghesi-Horizontal-Laser-Positioning
A MATLAB project to assist in the Borghesi-1022 experiment with aiming the laser at the least warped section of each target foil.

![3D-Graph-Example](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Borghesi%20Example%203D%20Graph%202.png?raw=true)

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
  - ```realMinZ```, the minimum height value in the original scan in um
  - ```realMaxZ```, the maximum height value in the original scan in um
- On line 62 replace ```r(i+k)``` with ```m(i+k)``` to change the warp indicator (explained below)

## A More Detailed Explanation
![3D Graph Example](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Borghesi%20Example%203D%20Graph%20Annotated.png?raw=true)

The algorithm works by searching the middle third of the foil horizontally, and finding the ```n``` adjacent columns of data that have the lowest average 'warp indicator'.

```n``` is calculated from the ```approx_beam_width_um``` value.

The 'warp indicator' is either:
 - ```m```, the gradient of the best fit line in the ```y```-axis
 - ```r```, the range (max - min) of the array slice's values

## More Information
The conversion from the interferometer .OPD file to a readable MATLAB matrix seems to corrupt the height data. A scaling and translational effect is produced, which depends on the scan's settings (e.g. magnification, field of view).

This algorithm only needs relative height data for finding the least warped section, but if absolute height values are required, the MATLAB array can be easily modified to fit the original data.

Below is an example of the original BRUKER interferometer scan.

![BRUKER Original Scan](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Original%20Scan%20Bruker.png?raw=true)
## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)