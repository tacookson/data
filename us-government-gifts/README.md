# U.S. Diplomatic Gifts



This data is about gifts given between 1999 and 2018 to U.S. federal employees from foreign government sources, such as when a foreign leader visits the U.S. and presents the President with a gift. Articles about these gifts pop up every few years, often prompted by a notable gift to the President or First Family from a visiting foreign leader. This [article](https://foreignpolicy.com/2017/04/27/eight-of-the-weirdest-gifts-foreign-dignitaries-gave-the-president/) from *Foreign Press* and this [listicle](https://www.mentalfloss.com/article/25375/white-house-gift-guide-13-unique-presidential-gifts) from *Mental Floss* lists some notable gifts.

Some personal favourites include items at the extreme low and high end of the value scale, as well as cute gifts:

1. Live shamrocks :four_leaf_clover:, given by Irish Prime Minister Bertie Ahern to President George W. Bush (estimated value: USD $5) (seems like a generous valuation to me, unless they're special shamrocks?)
2. Emerald and diamond jewellery set :gem:, including ring, earrings, bracelet, and necklace, given by King Abdullah of Saudi Arabia to Teresa Heinz Kerry, wife of Secretary of State John Kerry (estimated value: USD $780K)
3. Stuffed animals -- a koala :koala: and a kangaroo with a joey in its pouch -- for Sasha and Malia Obama (the First Children), gifted by Australian Prime Minister Julia Gillard (But they didn't get to keep them! They were transferred to the [National Archives and Records Administration](https://en.wikipedia.org/wiki/National_Archives_and_Records_Administration))



Data is from [FederalRegister.gov](https://www.federalregister.gov/), a website operated by the [U.S. Office of the Federal Register](http://www.archives.gov/federal-register/) and the [U.S. Government Publishing Office](http://www.gpo.gov/). The Federal Register is a website for finding all sorts of U.S. government documents.

Cornell Law School has the text of the [part of the U.S. Code](https://www.law.cornell.edu/uscode/text/5/7342) governing the "receipt and disposition of foreign gifts and decorations", if you're interested in the law governing foreign gifts.



# Data Dictionary

### `gifts.csv`

| variable         | class     | description                                                  |
| :--------------- | :-------- | :----------------------------------------------------------- |
| id               | integer   | Unique identifier -- doesn't have any real-world meaning     |
| recipient        | character | Name and/or title of gift recipient                          |
| agency_name      | character | Agency that the recipient is associated with                 |
| year_received    | double    | Year the gift was received. Based on `date_received` if available, otherwise based on reporting year of the source document. |
| date_received    | date      | Date the gift was received                                   |
| donor            | character | Name and/or title of donor                                   |
| donor_country    | character | Country associated with the donor                            |
| gift_description | character | Long-form description of gift, usually including physical description, date received, estimated value in U.S. dollars, and what was done with the gift (they are often sent to government agencies) |
| value_usd        | double    | Estimated U.S. dollar value of gift. If multiple values are in `gift_description`, this is the maximum value, which is usually the combined value of all gifts. |
| justification    | character | Justification for accepting the gift                         |
