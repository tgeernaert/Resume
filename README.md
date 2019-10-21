# Resume

Simple project that uses a JSON file as the desctiption of a textual view heirachy, and applies a theme.

* ViewDescriptor defines a protocol for defining a ViewType. Each View that is defined using this protocol 
  needs to have a corosponding ViewType added so that it can be parsed from the JSON.
* ViewType is an enum that provides a concretion for the decoding of JSON into a ViewDescriptor.
* JSONDataFetcher is abstracted behind a protocol...  three concrete version provided:
    * for unit testing.
    * for a bundled resource.
    * that fetches a specific url from gist.
* Theme is model object protocol and a version could easily be built to load from a file.
* Uses a view model with injected dependencies to allow for some unit testing.
