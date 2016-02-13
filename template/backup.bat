cd c:\semanager\worlds\asteroids\
call .\stop.bat
cd backups
move backup.9.zip backup.10.zip
move backup.8.zip backup.9.zip
move backup.7.zip backup.8.zip
move backup.6.zip backup.7.zip
move backup.5.zip backup.6.zip
move backup.4.zip backup.5.zip
move backup.3.zip backup.4.zip
move backup.2.zip backup.3.zip
move backup.1.zip backup.2.zip
move backup.zip backup.1.zip
cd ..
"c:\program files\7-zip\7z.exe" a backups\backup.zip data\Saves data\Storage data\*.cfg
