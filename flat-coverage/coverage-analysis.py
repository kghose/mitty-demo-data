import pandas as pd
import matplotlib.pyplot as plt

df_god = pd.read_csv('god.coverage', sep='\t', header=None,
                     names=['chrom', 'pos', 'cov'])
df_bwa = pd.read_csv('bwa.coverage', sep='\t', header=None,
                     names=['chrom', 'pos', 'cov'])

df_god[df_god['chrom'] == 20]['cov'].hist(
  bins=41, range=(0, 40), histtype='step', label='Actual')
df_bwa[df_bwa['chrom'] == 20]['cov'].hist(
  bins=41, range=(0, 40), histtype='step', label='BWA')
plt.legend()
plt.show()

plt.savefig('coverage.png')