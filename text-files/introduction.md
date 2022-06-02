### Abstract

Our primary concern is to determine which types of traffic collisions are most likely to occur in the City of Seattle and who is most likely to be involved. This is a critical question because it pertains to the public safety of our community and population. To address the question, we will examine our data to determine the most likely locations, vehicle types, and severity of collisions.

### Keywords

Seattle; traffic collisions; traffic injuries; pedestrians; vehicles.

### Introduction  

As teens and young adults, one major milestone and accomplishment is obtaining a driver's license. Throughout the driving course, students learn how to correctly maneuver a vehicle, laws regarding right-of-way, and the safety of everyone on the road. With this in mind, we are curious to see which scenarios account for the most injuries and deaths on the road as driving a car is the most common method of transportation in the United States.

1. Are collisions becoming more common as time progresses and more people are driving or does it remain the same throughout the years?
 
2. Which type of roads account for the most injuries and deaths?

3. What environmental factors (conditions) may have caused the incident?

4. What type of collision is more common?
 
5. What kind of injuries occur from collisions?

### The Dataset

This project is sourced from the [City of Seattle Official Website](https://data.seattle.gov/dataset/Collisions/g983-vrct), in which the data is collected by the [City of Seattle GIS Program](https://www.seattle.gov/tech/initiatives/open-data). All collisions are provided by SPD and recorded by Traffic Records. It is consistently updated every week. As of April 25, 2022, there are 234,522 rows (observations) and 40 columns (features) in this dataset. The data was collected in order for the city of Seattle to keep track of all collisions that occur within the city. When working with this data, the following ethical concerns should be addressed:

- Do certain factors, such as race or gender, influence the level of severity recorded for a collision?
- What factors influence whether a collision is recorded at all?
- Is a certain gender more likely to cause collisions than others?
- Does race play a role?

## Limitations and Challenges

In this dataset, there are a large number of observations, which means that it may be difficult to clean up and select useful data for further analysis. Because there are more than two hundred thousand rows of data, it will be difficult to find relevant information and focus our research on a few key questions. After a quick skim through the dataset, it becomes clear that there are numerous blank spaces and NA/null values. Despite the fact that it is desirable to have a diverse set of data, there is a possibility that certain columns will only contain a small number of entries, resulting in weaker evidence for us. Another issue with this dataset is that it is updated on a weekly basis, which is a constant source of contention. Because we insist on having the most up-to-date information, we have to download the new CSV file as soon as it is released on a regular basis. Another significant issue that arises is a lack of representation. With old data, the people who were collecting could have easily limited their records to people of color while neglecting to keep track of everyone else. Since the early 2000s, this dataset contains information, and it is useful to have historical information to compare with because there may be many discrepancies and inconsistencies as a result of technological advancement.

In general, this dataset is fairly concise but there are a few challenges and limitations. As one of the columns reports severity code, this could show observer bias since severity is subjective and can differ from person to person. There are also two different columns that describe injuries versus serious injuries but I think that it could be clearer what is considered an injury along with how to differentiate between a normal injury and a severe one. One solution to that is more than 3 severity codes so they can encompass more scenarios. There could also be reporting bias as another column reports speeding but participants may underreport or may not be willing to disclose that they were speeding. This dataset also doesn’t allow one to draw causation, only correlation. It would be difficult to say what the crash was caused by so it’s hard to draw conclusions and come out with an accurate experiment result.
