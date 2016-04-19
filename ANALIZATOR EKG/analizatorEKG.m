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
[plik, sciezka] = uigetfile('*.xls','Wybierz plik z danymi');
plik=strcat(sciezka,plik);
handles.a = xlsread(plik);
handles.wektor_czasowy=handles.a(:,1)
handles.dane_ekg=handles.a(:,2)
set(handles.info_czy_wczytal, 'String','Dane wczytane poprawnie');
guidata(hObject,handles);



% --- Executes on button press in wylicz_parametry.
function wylicz_parametry_Callback(hObject, eventdata, handles)
% hObject    handle to wylicz_parametry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.parametry=licz_parametry(handles.wektor_czasowy, handles.dane_ekg);
text=licz_parametry(handles.wektor_czasowy, handles.dane_ekg);
set(handles.parametry_text,'String',text);

guidata(hObject,handles)

% --- Executes on button press in wykres.
function wykres_Callback(hObject, eventdata, handles)
% hObject    handle to wykres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.czas=handles.wektor_czasowy-handles.wektor_czasowy(1);
set(handles.axes1,'visible','on')
plot(handles.czas, handles.dane_ekg)

title('Charakterystyka EKG')
xlabel('czas [s]')
ylabel('sygna³ [mV]')

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