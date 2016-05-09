function varargout = analizatorEKG(varargin)
% ANALIZATOREKG MATLAB code for analizatorEKG.fig
%      ANALIZATOREKG, by itself, creates a new ANALIZATOREKG or raises the existing
%      singleton*.
%
%      H = ANALIZATOREKG returns the handle to a new ANALIZATOREKG or the handle to
%      the existing singleton*.
%
%      ANALIZATOREKG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALIZATOREKG.M with the given input arguments.
%
%      ANALIZATOREKG('Property','Value',...) creates a new ANALIZATOREKG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analizatorEKG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analizatorEKG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analizatorEKG

% Last Modified by GUIDE v2.5 20-Mar-2016 21:56:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analizatorEKG_OpeningFcn, ...
                   'gui_OutputFcn',  @analizatorEKG_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before analizatorEKG is made visible.
function analizatorEKG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analizatorEKG (see VARARGIN)

%DANE WYŒWIETLANE NA POCZATKU:
handles.wykres=imshow('ekg.bmp')

% Choose default command line output for analizatorEKG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = analizatorEKG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in wczytaj_dane.
function wczytaj_dane_Callback(hObject, eventdata, handles)
% hObject    handle to wczytaj_dane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[plik, sciezka] = uigetfile('*.txt','Wybierz plik z danymi');
plik=strcat(sciezka,plik);
handles.dane_ekg = load(plik);

handles.wektor_czasowy=[1:length(handles.dane_ekg)]*0.001;

 


 
 
set(handles.info_czy_wczytal, 'String','Dane wczytane poprawnie');





guidata(hObject,handles);



% --- Executes on button press in wylicz_parametry.
function wylicz_parametry_Callback(hObject, eventdata, handles)
% hObject    handle to wylicz_parametry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.parametry=licz_parametry(handles.wektor_czasowy, handles.dane_ekg);
text=licz_parametry(handles.wektor_czasowy, handles.dane_ekg);
 


% wywo³anie funkcji detekcji
[handles.P_index,handles.P_value,handles.Q_index,handles.Q_value,handles.R_index,handles.R_value, ...
    handles.S_index, handles.S_value, handles.T_index, handles.T_value]=detekcja(handles.dane_ekg);
% 
% % parametry za³amka P
% [P_stop_index,P_start_index,P_length_AVR,P_amplitude_AVR]=fun_P_parameters(Q_index,P_index,P_value,handles.dane_ekg)
% 
% % parametry za³amka Q
% [Q_stop_index,Q_start_index,Q_length_AVR,Q_amplitude_AVR]=fun_Q_parameters(R_index,Q_value,Q_index,handles.dane_ekg)
% 
% % parametry za³amka R
% [R_stop_index,R_start_index,R_length_AVR,R_amplitude_AVR]=fun_R_parameters(S_index,R_value,R_index,handles.dane_ekg)
% 
% % parametry za³amka S
% [S_stop_index,S_start_index,S_length_AVR,S_amplitude_AVR]=fun_S_parameters(T_index,S_value,S_index,handles.dane_ekg)
% 
% % parametry za³amka T
% [T_stop_index,T_start_index,T_length_AVR,T_amplitude_AVR]=fun_T_parameters(P_index,T_value,T_index,handles.dane_ekg)

% % HR 
% [HR]=fun_HR(handles.dane_ekg,R_index)
% 
% % odstêp RR
% [RR_interwal_AVR]=fun_RR_interval(R_index);
% 
% %PQ
% [odcinek_PQ_AVR,odstep_PQ_AVR]=fun_PQ(P_start_index,P_stop_index,Q_start_index)
% 
% %QT
% [odstep_QT_AVR]=fun_QT(Q_start_index,T_stop_index)
% 
% %QRS
% [zespol_QRS_AVR]=fun_QRS(Q_start_index,S_stop_index)
% 
% %ST
% [odcinek_ST_AVR]=fun_ST(T_start_index,S_stop_index)

set(handles.parametry,'String',text);

guidata(hObject,handles)

% --- Executes on button press in wykres.
function wykres_Callback(hObject, eventdata, handles)
% hObject    handle to wykres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.czas=handles.wektor_czasowy-handles.wektor_czasowy(1);
set(handles.axes1,'visible','on')
%set(hObject.axes1,'toolbar','figure') 
plot (handles.wektor_czasowy,handles.dane_ekg); hold on;

plot (handles.wektor_czasowy(handles.R_index) ,handles.R_value(1:end) , 'r^', ...
    handles.wektor_czasowy(handles.S_index) ,handles.dane_ekg(handles.S_index),'o',... 
    handles.wektor_czasowy(handles.T_index) ,handles.dane_ekg(handles.T_index) ,'s' ... 
    ,handles.wektor_czasowy(handles.Q_index) ,handles.dane_ekg(handles.Q_index) , '*' ...
     ,handles.wektor_czasowy(handles.P_index) ,handles.dane_ekg(handles.P_index),'gs');   
 hold off;
 legend('EKG','R','S','T','Q','P');


title('Charakterystyka EKG')
xlabel('czas [s]')
ylabel('sygna³ [mV]')
xlim([2 5])
guidata(hObject,handles)


% --- Executes on button press in zapisz_do_pliku.
function zapisz_do_pliku_Callback(hObject, eventdata, handles)
% hObject    handle to zapisz_do_pliku (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.parametr=licz_parametry(handles.wektor_czasowy, handles.dane_ekg);
[nazwa,sciezka] = uiputfile('*.txt','Zapisz parametry do pliku  jako ...'); 
plik_nazwa=strcat(sciezka,nazwa);
save(plik_nazwa,handles.parametr);
%save(plik_nazwa,(handles.parametr),-ascii);

guidata(hObject,handles)

% --- Executes on button press in koniec.
function koniec_Callback(hObject, eventdata, handles)
% hObject    handle to koniec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% --- Executes on button press in informacje.
function informacje_Callback(hObject, eventdata, handles)
% hObject    handle to informacje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


string={'ANALIZATOR SYGNA£U EKG'...  
    ''...
    'Autor: Marta, Agata, Paulina'}
helpdlg(string,'O PROGRAMIE'); 
guidata(hObject,handles)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.parametry_text,'String','PACJENT ZDROWY/CHORY');

guidata(hObject,handles)