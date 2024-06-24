Non-metric Multidimensional Scaling (NMDS) is an ordination technique used in ecological and environmental studies to visualize the similarity or dissimilarity of data. NMDS is particularly useful for community ecology data, where it can be used to analyze species composition data. It is a rank-based approach that attempts to represent the dissimilarity (distance) between samples in as few dimensions as possible, while preserving the order of distances rather than their exact values.

NMDS aims to minimize the stress value, which measures the goodness of fit of the ordination. A lower stress value indicates a better representation of the dissimilarities in reduced dimensions.

Stress value of an NMDS ordination:
* Good fit: stress <= 0.05
* Fair: 0.05 < stress <= 0.1
* Suspect: stress ~ 0.2 (may not be reliable or meaningful)
* Arbitrary: stress ~ 0.3 (does not provide meaningful or interpretable patterns)

#### Bray-Curtis dissimilarity matrix
The Bray-Curtis dissimilarity matrix is a widely used measure in community ecology to quantify the dissimilarity between two sites based on the composition of species within each site.

Unlike other distance measures that might focus solely on presence or absence data, Bray-Curtis dissimilarity takes into account the abundance of species, making it especially useful for ecological datasets where species counts are important.

#### Jaccard dissimilarity matrix
The Jaccard dissimilarity matrix is a statistical tool used to measure the dissimilarity between sets, commonly used in ecology to assess the dissimilarity between community compositions.

It is based on the Jaccard index, which quantifies the similarity between finite sample sets and is defined as the size of the intersection divided by the size of the union of the sample sets.

It quantifies how different or similar various sets are, particularly in terms of species presence or absence. Its straightforward interpretation and the effective way it handles binary data make it particularly useful for studies involving categorical data.

#### Manhattan distance
Manhattan distance (also known as city block distance or L1 distance) is a useful dissimilarity measure that measures the distance between two points in a grid-based system, summing the absolute differences of their coordinates. In the context of ecological data, it can be used to assess the dissimilarity between samples based on species abundance or presence/absence data.
