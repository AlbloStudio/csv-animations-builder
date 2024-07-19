# csv-animations-builder
This is a plugin for Godot that reads properties from a CSV file, creates animations based on the data, and integrates them into the `AnimationPlayer`.

## How to Use

### Preparations
- Ensure your scene includes a `Sprite2D` and an `AnimationPlayer`, with the `Sprite2D` set as the root node.
- Prepare a CSV file following the format provided in the example [here](addons/csv-animations-builder/example/Atlas_Animations_Data.csv). See [CSV File](#csv-file) for more details.
- Have an image containing all the frames for your animations, either as an Atlas or a Sprite Sheet. This image will serve as the texture for your `Sprite2D`.

## Importing the CSV
- In the editor, select the CSV file and navigate to the 'Import' tab.
- Choose 'CSV Data' as the import type.
- Click the 'Import' button below.

## Adding the Node to Your Scene
- Add the `AnimationsImporter` node as a child of your `AnimationPlayer`.
- Assign your CSV file to the `Csv Resource` property.
- A list will appear showing the animations that will be configured in the `AnimationPlayer`.
- Click on 'Import Animations'.
- The existing animations in the `AnimationPlayer` will be removed and replaced with the new ones from the CSV.

## Intention
- The purpose of this plugin is to allow your artist, animator, or you (Hi, solo developer), to manage the CSV with all updates or changes to the animations. Whenever the CSV is updated, simply re-import the CSV and re-import the animations through the node. You won't have to add animations by hand anymore!

## CSV File
- The CSV file should contain the following columns:
  - `animation_name`: The name of the animation.
  - `frame_coords_start_x` / `frame_coords_start_y`: Coordinates in pixels of the lower-left corner of the region encapsulating this animation on your atlas.
  - `frame_size_x` / `frame_size_y`: The size of this animation region in pixels.
  - `frame_duration_ms`: The duration each frame appears on the screen in milliseconds. This is the inverse of frames per second.
  - `frame_count`: The number of frames in your animation.
  - `autoplay_on_load`: Specifies whether this animation should play upon game start. Set this to true for only one animation.
  - `loop`: Indicates whether this animation should repeat (loop) upon completion.
