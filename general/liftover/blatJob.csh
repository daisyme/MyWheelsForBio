#!/bin/bash
#$ -q bio,adl,abio,pub64,pub8i
module load blat
export PATH=/data/users/ytao7/software/kentUtils/src/parasol/bin:/data/users/ytao7/software/kentUtils/bin/linux.x86_64:$PATH

root='/share/adl/ytao7/summer/liftover/SameSpeciesTry/run.blat/'
targetList=$root$1
queryListIn=$root$2
outPsl=$3

# Use local disk for output, and move the final result to $outPsl
# when done, to minimize I/O.
tmpDir=`mktemp -d -p /dev/shm doSame.blat.XXXXXX`
pushd $tmpDir

# We might get a .lst or a 2bit spec here -- convert to (list of) 2bit spec:
if ((${queryListIn##*.} == "lst")) 
then
  specList=`cat $queryListIn`
else
  specList=$queryListIn
fi

# Further partition the query spec(s) into 5000 coord ranges, building up
# a .lst of 2bit specs for blat and a .lft liftUp spec for the results:
cp /dev/null reSplitQuery.lst
cp /dev/null query.lft

for spec in $specList
do
  file=`echo $spec | awk -F: '{print $1;}'`
  seq=`echo $spec | awk -F: '{print $2;}'`
  range=`echo $spec | awk -F: '{print $3;}'`
  start=`echo $range | awk -F- '{print $1;}'`
  end=`echo $range | awk -F- '{print $2;}'`
  if [ ! -e q.sizes ];then twoBitInfo $file q.sizes;fi
  seqSize=`awk '$1 == "'$seq'" {print $2;}' q.sizes`
  chunkEnd='0'
  while [ $chunkEnd -lt $end ]
  do
    chunkEnd=`echo $start 5000 | awk '{print $1+$2}'`
    if (($chunkEnd > $end));then chunkEnd=$end;fi
    chunkSize=`echo $chunkEnd $start | awk '{print $1-$2}'`
    echo $file\:$seq\:$start-$chunkEnd >> reSplitQuery.lst
    if ((($start == 0)) && (($chunkEnd == $seqSize))) 
    then
      echo "$start      $seq    $seqSize        $seq    $seqSize" >> query.lft
    else
      echo "$start      $seq"":$start-$chunkEnd $chunkSize      $seq    $seqSize" >> query.lft
    fi
    start=`echo $chunkEnd 500 | awk '{print $1-$2}'`
  done
done

# Align unsplit target sequence(s) to .lst of 2bit specs for 5000 chunks
# of query:
blat $targetList reSplitQuery.lst tmpUnlifted.psl \
  -tileSize=11 -ooc=${root}11.ooc \
  -minScore=100 -minIdentity=98 -fastMap -noHead

# Lift query coords back up:
liftUp -pslQ -nohead tmpOut.psl query.lft warn tmpUnlifted.psl

# Move final result into place:
mv tmpOut.psl $outPsl

popd
rm -rf $tmpDir

