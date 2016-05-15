
Informacje o controlsach https://www.physionet.org/physiobank/database/ptbdb/CONTROLS

Informacje o danych eksperymentalnych https://www.physionet.org/physiobank/database/ptbdb/


1. Zgromadzono zbiór danych eksperymentalnych zawierający sygnały EKG grupy kontrolnej oraz osób, u których zdiagnozowano zaburzenia układu krążenia.
2. Zaimplementowano algorytm detekcji załamków P,Q,R,S,T metodą "Pan-Tompkins".
3. Opracowano metodę obliczania częstości pracy serca oraz czasu trwania odcinka RR.
4. Zaimplementowano funkcje wyznaczające amplitudy i czasy trwania załamków P,Q,R,S,T.
5. Wyznaczono parametry sygnałów zawartych w folderze DaneZapisane. Wyniki analizy umieszczono w pliku patientsDATA.txt.
   Poszczególne kolumny zawierają następujące dane: P_amplitude_AVR P_length_AVR Q_amplitude_AVR Q_length_AVR R_amplitude_AVR R_length_AVR S_amplitude_AVR S_length_AVR T_amplitude_AVR T_length_AVR odstep_PQ_AVR odstep_QT_AVR zespol_QRS_AVR odcinek_PQ_AVR odcinek_ST_AVR HR RR_interwal_AVR GRUPA ID.
   GRUPA oznacza klasyfikację chory/zdrowy(0/1), ID to identyfikator pliku z zapisem oryginalnego sygnału.
 
6. Zmodyfikowano GUI - sygnał wczytywany do analizy w formie wektora (tylko 1 kanał EKG) z pliku txt
7. Opracowano klasyfikację pacjentów za pomocą klasteryzacji K-means. 
8. Wyznaczono najistotniejsze składowe metodą PCA.
