## iOS App Overview

*WalmartSearch has the following required features:*
- Search -
    - type a search term in the search bar to view a list of items
    - results are shown in a table view
    
- Details -
    - tap on an item from the search results to view its details
    - shown in a view controller that is pushed onto the navigation stack
    
- Recommendations -
    - shown in a horizontally-scrolling collection view at the bottom of the details page
    - tap a recommended item to populate the details page with its details

*Extra features I added:*
- Trending items feed -
    - shown in a horizontally-scrolling collection view at the bottom of the search results page
    - tap an item to navigate to the details page & view its details
    

## To Run the App

- Clone the iOS repository
- Open the WalmartSearch.xcworkspace file in XCode
- Run on simulator or connected device


## To Run the Tests

- I am new to writing tests, but I did experiment with tests for the app

- For Unit Tests
    - Open the WalmartSearchTests.swift file in the WalmartSearchTests target
    - Click the play icon next to the class declaration
    
- For UI Tests
    - Open the WalmartSearchUITests.swift file in the WalmartSearchUITests target
    - Click the play icon next to the class declaration

