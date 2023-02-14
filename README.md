# Borghesi-Horizontal-Laser-Positioning
A MATLAB project to assist the Borghesi-1022 experiment by finding the least warped section of each foil in each Borghesi microtarget array.

<figure>
<img
  src="https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Latest%20example%20plot%20cropped%20wsubtitle.png?raw=true"
  style="display: block; 
          margin-left: auto;
          margin-right: auto;">
<figcaption align = "center"><b>Example result plot</b></figcaption>
</figure>

The foils are individually scanned using a white light interferometer normal to the surface of the foil. The resulting height map is then saved in the .OPD file format and uploaded to the ___Characterisation Data___ directory of this repository. Information about the foil such as its corresponding data file's name is given by the user to the _main.m_ script, which then uses an algorithm (explained below) to determine location of its least warped section. A plot of the foil's 3D surface that includes the relevant result annotations can then be plotted.

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
  - `reference_bounds`, the *x* locations (in data rows) of the inner left and right edges of the L-shaped foil mount
  - `approx_beam_width_um`

The `filePath` should not depend on where you store the repository - it should be a local path, e.g. `'Characterisation Data\Array3\'`. The `reference_bounds` have to be found and entered manually as these positions change between scans and can be subjective. It is recommended to run `main.m` with arbitrary `reference_bounds` values and use the 3D plot to determine them before restarting the script.

The image below shows the naming convention used for filenames in the ___Array Target Characterisation.xlsx___ spreadsheet.

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


Various metrics such as dimensions, material, and surface roughness can also be found in  ___Array Target Characterisation.xlsx___. Each row corresponds to a different target.

## A More Detailed Explanation

The algorithm tries to find the least warped section of the foil. It looks only at the middle third of the section between the reference bounds. These 'middle third bounds' are displayed with blue dashed lines, and the reference bounds are shown in black.

<figure>
<img
  src="https://github.com/10Electra/Borghesi-Horizontal-Laser-Positioning/blob/main/images%20and%20examples/Annotated%20Example%20cropped.png?raw=true"
  style="display: block; 
          margin-left: 0px;
          margin-right: 0px;">
<figcaption align = "center"><b>Example Result Plot</b></figcaption>
</figure>

The algorithm's output is the location of the centre of a certain section of the foil that is `beam_width_um` μm wide. The bounds of this section are marked with the red dotted lines. The `beam_width_um` is converted to a width of `n` data point readings.

This 'certain section' of foil was chosen as it either maximises or minimises the chosen _warp indicator(s)_, measured for each data column / array slice in the section and averaged.

### Warp Indicators
The _warp indicator_ now used on the `main` branch of this repository is described below.

Recently, it was observed that the angle of the target wheel is able to be adjusted, so we can search for relative flatness, as opposed to absolute angle flatness (e.g. $\theta=0°$ or $m=0$).

This relative flatness can be approximated by the coefficient of determination ($R^2$ value) of the array slice's best fit line.

The only issue with this approach is that the algorithm will not take into account any flat twist (like any section of a Möbius strip). If the approx beam width is not thin, (`n > 1`) this flat twist will be problematic and should be minimised.

An indicator of the flat twist of the foil in a certain section is the standard deviation or variance of the array slices in that section.

It was decided not to calculate this 'flat twist indicator' as finding the right weighted sum would have been difficult. Instead, only the coefficient of determination is used and the user is presented with a 3D surface plot or sequential 2D slice plots of the result section to check it for flat twist. These plots are made available with the included but commented _lines 58_ and _59_ in `[+Utils\]LeastWarpedSection.m`, which make use of the `PlotSlices` and `PlotSlices3D` functions.

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
