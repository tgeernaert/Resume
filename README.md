# Resume

Simple project that uses a JSON file as the desctiption of a view heirachy and applies a theme.

* JSON fetcher is abstracted behind a protocol...  three concrete version provided
    * one for unit testing
    * one for a bundled resource
    * one that fetches a specific url fron a gist
* Theme is model object protocol and a version could easily be built to load from a file.
* Uses a view model with dependency injection to allow for some unit testing
* ViewDescriptor defines a protocol for defining a ViewType. Each View that is defined using this protocol 
  needs to have a corosponding ViewType added so that it can be parsed from the JSON.
* ViewType is an enum that provides a concretion for the decoding of JSON into a ViewDescriptor.
