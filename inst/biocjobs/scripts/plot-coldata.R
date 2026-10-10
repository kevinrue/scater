## BiocJobs job script: plot-coldata
## The declared interface lives in ../plot-coldata.yaml; jobParams() parses the
## command line against it, so every value below is typed, validated and
## defaulted by the time it returns.

## Test command (R)
## BiocJobs::runJob(BiocJobs::readJob("inst/biocjobs/plot-coldata.yaml"), params = list(infile = "test-data/sce.rna-qc.h5ad", y = "sum", width = 5L, height = 3L, outfile = "test-data/sum.pdf"))

## Validation command (Bash)
## Rscript -e 'BiocJobs::biocjobsCLI()' validate .

# Rscript -e 'BiocJobs::biocjobsCLI()' galaxy   . plot-coldata --out wrappers/plot-coldata.xml
# Rscript -e 'BiocJobs::biocjobsCLI()' nextflow . plot-coldata --out wrappers/plot-coldata.nf

params <- BiocJobs::jobParams("scater", "plot-coldata")

## -- your analysis ---------------------------------------------------------
## Read inputs from params$<input name>, honour params$<option name>, and
## write every declared output to params$<output name>. Fail loudly with
## stop() on bad input; never prompt or open devices interactively.

suppressPackageStartupMessages({
  library(anndataR)
  library(ggplot2)
  library(scater)
})

sce <- anndataR::read_h5ad(params$infile, as = "SingleCellExperiment")

plot <- scater::plotColData(
  object = sce,
  y = params$y
  ) +
  ggplot2::scale_y_log10()

ggplot2::ggsave(
  filename = params$outfile,
  plot = plot,
  width = params$width,
  height = params$height
)

## Provenance to the job log.
message(paste(utils::capture.output(utils::sessionInfo()), collapse = "\n"))
