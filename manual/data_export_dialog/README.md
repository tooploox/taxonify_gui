# Data export dialog

This is the data export dialog. It can be opened by clicking on the `Export` button in the [Main view](../main_view/README.md). Data export dialog allows user to export the data (annotated or not) from the system.

<p align="center">
  <img src="static/data_export_dialog_overview.png" border=1>
</p>

Data export dialog consists of few elements:

1. Export filter - this component allows user to specify what data is to be exported form the system. Its behaviour is analogical to [Filtering pane](../filtering_pane/README.md).
2. Include images checkbox - this checkbox specifies whether exported data should contain images or not. This feature is currently disabled.
3. Limit results field - this field allows limiting the number of results to the specified value.
4. Export summary - short summary of chosen export preferences.
5. Cancel button - button that invalidates export operation and lets user exit the dialog.
6. Ok button - button that confirms chosen export preferences and initializes export operation. For the time of preparing the export file text changes into running busy indicator. When the export file is ready it is downloaded via external web browser.

## Export file format
Data is exported as a single `.tsv` file which contains all the records that match provided export criteria with all the fields that are in the system.
