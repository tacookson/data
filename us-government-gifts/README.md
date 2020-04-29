# U.S. Government Gifts



This data is about gifts to U.S. federal employees from foreign government sources, such as when a foreign leader visits the U.S. and presents the President with a gift. Articles about these gifts pop up every few years, often prompted by a notable gift to the President or First Family from a visiting foreign leader. This [article](https://www.theatlantic.com/politics/archive/2016/02/the-unusual-gifts-given-to-presidents/462831/) from *The Atlantic* (soft paywall) lists some notable gifts.

Some personal favourites include items at the extreme low (1) and high end (2) of the value scale and cute items (3) :

1. Live shamrocks, given by Irish Prime Minister Bertie Ahern to President George W. Bush (estimated value: USD $5)
2. Emerald and diamond jewellery set, including ring, earrings, bracelet, and necklace, given by King Abdullah of Saudi Arabia to Teresa Heinz Kerry, wife of Secretary of State John Kerry (estimated value: USD $780K)
3. Stuffed animals -- a koala and a kangaroo with a joey in its pouch -- for Sasha and Malia Obama (the First Children), gifted by Australian Prime Minister Julia Gillard (But they didn't get to keep them! They were transferred to the [National Archives and Records Administration](https://en.wikipedia.org/wiki/National_Archives_and_Records_Administration))



Data is from [FederalRegister.gov](https://www.federalregister.gov/), a website operated by the [U.S. Office of the Federal Register](http://www.archives.gov/federal-register/) and the [U.S. Government Publishing Office](http://www.gpo.gov/). The Federal Register is a website for finding all sorts of U.S. government documents.



# Data Dictionary

### `gifts.csv`

| variable         | class     | description                                                  |
| :--------------- | :-------- | :----------------------------------------------------------- |
| recipient        | character | Name and/or title of gift recipient                          |
| agency_name      | character | Agency that the recipient is associated with                 |
| date_received    | date      | Date the gift was received                                   |
| donor            | character | Name and/or title of donor                                   |
| donor_country    | character | Country associated with the donor                            |
| gift_description | character | Long-form description of gift, including physical description, date received, estimated value in U.S. dollars, and what was done with the gift (they are often sent to government agencies) |
| value_usd        | double    | Estimated U.S. dollar value of gift. If multiple values are in `gift_description`, this is the maximum value, which is usually the combined value of all gifts |
| justification    | character | Justification for not refusing the gift. There are many variants of the same justification with different spelling or punctuation. |
