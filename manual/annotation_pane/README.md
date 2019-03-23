# Annotation pane

Annotation pane is a component where user chooses his or hers current annotation preferences. The Annotation pane can be in one of 3 possible states:

- initial state - no active annotation preferences

<p align="center">
  <img src="static/annotation_pane_initial.png" border=1>
</p>

- taxonomic annotation - meant for annotating the data with taxonomic values. Behaviour of taxonomy component is analogical to the one from [Filtering pane](../filtering_pane/README.md#Taxonomy).

<p align="center">
  <img src="static/annotation_pane_taxonomy.png" border=1>
</p>

- additional attributes annotation

<p align="center">
  <img src="static/annotation_pane_additional_attribute.png" border=1>
</p>

Those states cannot be combined, which also effectively means that user is unable to annotate data with a combination of taxonomic values and additional attributes values. It always has to be either of those and for additional attributes it's one attribute at the time.