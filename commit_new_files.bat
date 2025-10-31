@echo off
echo Committing new files individually...

git add 00_saa_c03_exam_guide.md
git commit -m "[GENERAL] SAA-C03 exam guide and study plan"

git add saa_c03_template.md
git commit -m "[GENERAL] SAA-C03 enhancement template"

git add saa_c03_coverage_analysis.md
git commit -m "[GENERAL] SAA-C03 exam coverage analysis"

git add 17_s3_versioning.md
git commit -m "[S3] Enhanced versioning with SAA-C03 exam focus"

git add 19_s3_snow_family.md
git commit -m "[S3] Snow family data transfer devices"

echo All new files committed individually!