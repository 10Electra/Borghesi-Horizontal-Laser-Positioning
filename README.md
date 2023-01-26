# Borghesi-Horizontal-Laser-Positioning
A MATLAB project to assist in the Borghesi-1022 experiment with aiming the laser at the least warped section of each target foil.

![3D-Graph-Example](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Borghesi%20Example%203D%20Graph%202.png?raw=true)

## Installation

Clone this repository into a local directory!

## Usage

- Run the ``` main.m``` script
- Edit the following variables to fit the current data
  - ```filePath```,
  - ```fileName```,
  - ```left_foil_bound```,
  - ```right_foil_bound``` and
  - ```approx_beam_width_um```
- On line 61 replace ```r(i+k)``` with ```m(i+k)``` to change the warp indicator

## A More Detailed Explanation
![3D Graph Example](https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Borghesi%20Example%203D%20Graph%20Annotated.png?raw=true)

The algorithm works by searching the middle third of the foil horizontally, and finding the ```n``` adjacent columns of data that have the lowest average 'warp indicator'.

```n``` is calculated from the ```approx_beam_width_um``` value.

The 'warp indicator' is either:
 - ```m```, the gradient of the best fit line in the ```y```-axis
 - ```r```, the range (max - min) of the array slice's values

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)