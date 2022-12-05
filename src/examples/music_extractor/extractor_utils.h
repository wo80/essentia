#include <essentia/pool.h>
#include <essentia/algorithmfactory.h> 

using namespace essentia;

void setExtractorDefaultOptions(Pool &options);
void setExtractorOptions(const std::string& filename, Pool& options);
void mergeValues(Pool& pool, Pool& options);
void outputToFile(Pool& pool, const std::string& outputFilename, Pool& options);

