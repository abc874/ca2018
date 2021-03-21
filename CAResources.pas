unit CAResources;

interface

resourcestring

  { Main }
  RsNotAvailable                   = 'N/A';
  RsCaptionCutApplication          = 'Cut app.: %s';
  RsNoCutsDefined                  = 'No cuts defined.';
  RsCouldNotCreateTargetPath       = 'Could not create target file path %s. Abort.';
  RsTargetMovieAlreadyExists       = 'Target file already exists:'#13#10
                                   + #13#10
                                   + '%s'#13#10
                                   + #13#10
                                   + 'Overwrite?';
  RsSaveCutMovieAs                 = 'Save cut movie as...';
  RsCouldNotDeleteFile             = 'Could not delete existing file %s. Abort.';
  RsCaptionTotalCutoff             = 'Total cutoff: %s';
  RsCaptionResultingDuration       = 'Resulting movie duration: %s';
  RsCouldNotInsertSampleGrabber    = 'Could not insert sample grabber.';
  RsErrorOpenMovie                 = 'Could not open Movie!'#13#10
                                   + 'Error: %s';
  RsErrorFileNotFound              = 'File not found: '#13#10
                                   + '%s';
  RsCannotLoadCutlist              = 'Cannot load cutlist. Please load movie first.';
  RsTitleMovieMetaData             = 'Movie Meta Data';
  RsMovieMetaDataMovietype         = 'Filetype: %s';
  RsMovieMetaDataCutApplication    = 'Cut application: %s';
  RsMovieMetaDataFilename          = 'Filename: %s';
  RsMovieMetaDataFrameRate         = 'Frame Rate: %s';
  RsMovieMetaDataVideoFourCC       = 'Video FourCC: %s';
  RsMovieMetaDataUnknownDataFormat = '***unknown data format***';
  RsMovieMetaDataNoInterface       = '***Could not find interface***';
  RsCutlistSavedAs                 = 'Cutlist saved successfully to'#13#10
                                   + '%s.';
  RsFilterDescriptionWmv           = 'Windows Media Files';
  RsFilterDescriptionAvi           = 'AVI Files';
  RsFilterDescriptionMp4           = 'MP4 Files';
  RsFilterDescriptionAllSupported  = 'All Supported Movie Files';
  RsFilterDescriptionAll           = 'All Files';
  RsFilterDescriptionBitmap        = 'Bitmap Files';
  RsFilterDescriptionJpeg          = 'Jpeg Files';

  RsFilterDescriptionAsf           = 'Asf Movie Files';

  RsExUnableToOpenKey              = 'Unable to open key "%s".';

  RsRegDescCutlist                 = 'Cutlist for Cut Assistant';
  RsRegDescCutlistOpen             = 'Open with Cut Assistant';
  RsRegDescMovieOpen               = 'Edit with Cut Assistant';

  RsErrorRegisteringApplication    = 'registering application.';
  RsErrorUnRegisteringApplication  = 'unregistering application.';

  RsMsgUploadCutlist               = 'Your Cutlist'#13#10
                                   + '%s'#13#10
                                   + 'will now be uploaded to the following site: '#13#10
                                   + '%s'#13#10
                                   + 'Continue?';
  RsMsgSaveChangedCutlist          = 'Save changes in current cutlist?';
  RsTitleSaveChangedCutlist        = 'Cutlist not saved';
  RsCutAppAsfBinNotFound           = 'Could not get Object CutApplication Asfbin.';

  RsTitleRepairMovie               = 'Select File to be repaired:';

  RsMsgRepairMovie                 = 'Current movie will be repaired using %s.'#13#10
                                   + 'Original file will be saved as '#13#10
                                   + '%s'#13#10
                                   + 'Continue?';
  RsMsgRepairMovieRenameFailed     = 'Could not rename original file. Abort.';
  RsMsgRepairMovieFinished         = 'Finished repairing movie. Open repaired movie now?';

  RsTitleCheckCutMovie             = 'Select File to check:';
  RsErrorMovieNotFound             = 'Movie File not found.';
  RsErrorCouldNotLoadMovie         = 'Could not load cut movie.';
  RsErrorCouldNotLoadCutMovie      = 'Could not load cut movie!'#13#10
                                   + 'Error: %s';

  RsCutApplicationWmv              = 'WMV Cut Application';
  RsCutApplicationAvi              = 'AVI Cut Application';
  RsCutApplicationHqAvi            = 'HQ Avi Cut Application';
  RsCutApplicationHdAvi            = 'HD Avi Cut Application';
  RsCutApplicationMp4              = 'MP4 Cut Application';
  RsCutApplicationOther            = 'Other Cut Application';

  RsTitleCutApplicationSettings    = 'Cut Application Settings';

  RsErrorUnknown                   = 'Unknown error.';
  RsMsgSearchCutlistNoneFound      = 'Search Cutlist: No Cutlist found.';
  RsErrorSearchCutlistXml          = 'XML-Error while getting cutlist infos:'#13#10'%s';

  RsMsgSendRatingNotPossible       = 'Current cutlist was not downloaded. Rating not possible.';
  RsMsgSendRatingDone              = 'Rating done.';
  RsMsgSendRatingNotDone           = 'Rating not done!'#13#10
                                   + #13#10;
  RsMsgAnswerFromServer            = 'Answer from Server:'#13#10
                                   + '%s';

  RsErrorUploadCutlist             = 'Error uploading cutlist: ';

  RsMsgCutlistDeleteUnexpected     = 'Delete command sent to server, but received unexpected response from server.';
  RsMsgCutlistDeleteEntryRemoved   = 'Database entry removed.';
  RsMsgCutlistDeleteEntryNotRemoved= 'Database entry not removed.';
  RsMsgCutlistDeleteFileRemoved    = 'File removed.';
  RsMsgCutlistDeleteFileNotRemoved = 'File not removed.';

  RsMsgAskUserForRating            = 'Please send a rating for the current cutlist.'#13#10
                                   + 'Would you like to do that now?';

  RsCutAssistantSupportRequest     = 'CutAssistant %s support request';

  RsDownloadCutlistWarnChanged     = 'Trying to download this cutlist:'#13#10
                                   + '%s [ID=%s]'#13#10
                                   + 'Existing cutlist is not saved and changes will be lost.'#13#10
                                   + 'Continue?';

  RsMsgOpenHomepage                = 'Open cutlist homepage in webbrowser?';
  RsDownloadCutlistInvalidData     = 'Server did not return any valid data (%d bytes). Abort.';
  RsErrorCreatePathFailedAbort     = 'Could not create cutlist path %s. Abort.';

  RsWarnTargetExistsOverwrite      = 'Target File already exists :'#13#10
                                   + #13#10
                                   + '%s'#13#10
                                   + #13#10
                                   + 'Overwrite?';

  RsErrorDeleteFileFailedAbort     = 'Could not delete existing file %s. Abort.';

  RsErrorConvertUploadData         = 'XML-Error while converting upload infos.'#13#10
                                   + '%s';

  RsErrorDownloadInfo              = 'Error while checking for Information and new Versions on Server.'#13#10;
  RsErrorDownloadInfoXml           = '%sXML-Error: %s';

  RsMsgInfoMessage                 = 'Information: %s';
  RsMsgInfoDevelopment             = 'Development Version Information: %s';
  RsMsgInfoStable                  = 'Stable Version Information: %s';

  RsTitleSaveSnapshot              = 'Save Snapshot as...';

  RsErrorExternalCall              = 'Error while calling %s: %s';

  RsErrorHttpFileNotFound          = 'File not found on server: %s';

  RsProgressTransferAborted        = 'Transfer aborted ...';
  RsErrorTransferAborting          = 'Transfer error. Aborting ...';

  RsProgressReadData               = 'Read %5d bytes from host.';
  RsProgressWroteData              = 'Wrote %5d bytes to host.';

  { CodecSettings }
  RsCheckingSourceFilterStart      = 'Checking Filters. Please wait ...';
  RsSourceFilterNone               = 'none';
  RsCheckingSourceFilter           = 'Checking Filter (%3d/%3d)';
  RsErrorCheckingSourceFilter      = 'Error while checking Filter %s'#13#10
                                   + 'ClassID: %s'#13#10
                                   + 'Error: %s';
  RsCheckingSourceFilterEnd        = 'Checking Filters. Done.';
  RsCodecUseDefault                = 'use default';
  RsCodecDummyName                 = 'none';
  RsCodecDummyDesc                 = '(Do not include Codec information)';
  RsErrorCloseCodec                = 'Could not close Compressor.';

  { CutlistRate-dialog }
  RsTitleConfirmRating             = 'Please confirm preselected rating ...';
  RsMsgConfirmRating               = 'Do you want to use the proposed rating for the cutlist?'#13#10
                                   + #13#10
                                   + '  %s';

  { UCutlist }
  RsMsgCutlistSaveChanges          = 'Save changes in current cutlist?';
  RsTitleCutlistSaveChanges        = 'Cutlist not saved';
  RsMsgCutlistNoCutsDefined        = 'No cuts defined.';
  RsErrorCutlistCutOverlap         = 'Planned Cut is overlapping with cut #%d. Cut cannot be added.';
  RsCaptionCutlistAuthorUnknown    = 'Cutlist Author unknown';
  RsCaptionCutlistAuthor           = 'Cutlist by %s';
  RsCutlistTargetUnknown           = 'Not found';
  RsMsgCutlistTargetMismatch       = 'Cut List File is intended for file:'#13#10
                                   + '%s'#13#10
                                   + 'However, current file is: '#13#10
                                   + '%s'#13#10
                                   + 'Continue anyway?';
  RsMsgCutlistCutAppMismatch       = 'Cut List File is intended for Cut Application:'#13#10
                                   + '%s'#13#10
                                   + 'However, current Cut Application is: '#13#10
                                   + '%s'#13#10
                                   + 'Continue anyway?';
  RsMsgCutlistCutAppVerMismatch    = 'Cut List File is intended for Cut Application:'#13#10
                                   + '%s %s'#13#10
                                   + 'However, current Cut Application version is: '#13#10
                                   + '%s'#13#10
                                   + 'Continue anyway?';
  RsMsgCutlistAsfbinOptionMismatch = 'Loaded options for external cut application are:'#13#10
                                   + '%s'#13#10
                                   + 'However, current options are:'#13#10
                                   + '%s'#13#10
                                   + 'Replace current options by loaded options?';

  RsTitleCutlistFrameRateMismatch  = 'Frame rate difference';
  RsMsgCutlistFrameRateMismatch    = 'The frame rate of the cutlist differs from the frame rate of the movie file.'#13#10
                                   + 'If the rate of the movie file is used, you may get a different result'#13#10
                                   + 'as expected by the author of the cutlist.'#13#10
                                   + #13#10
                                   + 'Frame rate of cutlist:    %.6f'#9'Frame rate of movie file: %.6f'#13#10
                                   + 'Using the frame rate of the movie file can result up to a difference of %d frames.'#13#10
                                   + #13#10
                                   + 'Do you want to use the frame rate of the cutlist?'#13#10
                                   + '(Selecting "No" will use the frame rate of the movie file)';
  RsMsgCutlistLoaded               = '%d of %d Cuts loaded.';
  RsSaveCutlistAs                  = 'Save cutlist as...';
  RsFilterDescriptionCutlists      = 'Cutlists';
  RsMsgCutlistReplaceAuthor        = 'Do you want to replace the Author name of this cutlist'#13#10
                                   + '"%s"'#13#10
                                   + 'by your own User Name?';
  RsCutlistInternalComment         = 'The following parts of the movie will be kept, the rest will be cut out.'
                                   + 'All values are given in seconds.';

  { Movie }
  RsMovieFrameRateNotAvailable     = 'fps: N/A';
  RsMovieFrameRateAvailable        = '%.5f fps';
  RsMovieFrameRateSource           = '%s (%s)';
  RsMovieTypeUnknown               = '[Unknown]';
  RsMovieTypeWmf                   = 'Windows Media File';
  RsMovieTypeAvi                   = 'AVI File';
  RsMovieTypeMp4                   = 'MP4 Iso File';
  RsMovieTypeHqAvi                 = 'HQ AVI File';
  RsMovieTypeHdAvi                 = 'HD AVI File';
  RsMovieTypeNone                  = '[None]';

  { Settings_dialog }
  RsTitleCutMovieDestinationDirectory = 'Destination directory for cut movies:';
  RsTitleCutlistDestinationDirectory  = 'Destination directory for cutlists:';
  RsCutMovieDirectoryMissing          = 'Cut movie directory does not exist:'#13#10
                                      + #13#10
                                      + '%s'#13#10
                                      + #13#10
                                      + 'Create?';
  RsCutlistDirectoryMissing           = 'Cutlist save directory does not exist:'#13#10
                                      + #13#10
                                      + '%s'#13#10
                                      + #13#10
                                      + 'Create?';
  RsErrorInvalidValue                 = 'Invalid value: %s';

  { UfrmCutting }
  RsErrorCleanUpCutting               = 'Error while cleaning up after cutting.';
  RsMsgWarnOnTerminateCutApplication  = 'The Cut Application will be terminated immediately!'#13#10
                                      + 'This may result in unexpected behaviour of the Cut Application.'#13#10
                                      + #13#10
                                      + 'Do you really want to terminate the Application?';
  RsTitleWarning                      = 'Warning.';
  RsCaptionCuttingClose               = '&Close';
  RsCaptionCuttingAutoClose           = '&Close (%d)';

  { Utils }
  RsExpectedErrorHeader               = 'Error while %s:'#13#10
                                      + #13#10;
  RsExpectedErrorFormat               = '%s(%s) %s';
  RsErrorFileVersionGetFileVersion    = '[Error getting file version: %s]';
  RsErrorFileVersionFileNotFound      = '[File not found: %s]';

  { UCutApplicationBase }
  RsCutAppNotFound                    = '%s not found (%s). Please check settings.';
  RsMsgCutAppTempDirMissing           = 'Directory for temporary files does not exist:'#13#10
                                      + #13#10
                                      + '%s'
                                      + #13#10
                                      + #13#10
                                      + 'Create it?';
  RsCutAppOutNoOutputRedirection      = 'Output redirection not activated.';
  RsCutAppInfoBase                    = 'Name: %s'#13#10
                                      + 'Path: %s'#13#10
                                      + 'Version: %s'#13#10;
  RsCutAppOutFinished                 = 'Finished.';
  RsCutAppOutErrorCommand             = 'Error. Last started Command Line was:';
  RsCutAppOutUserAbort                = 'Aborted by User.';
  RsTitleSelectCutApplication         = 'Select %s application:';
  RsCutAppPathTo                      = 'Path to %s';
  RsCutAppPathToMore                  = '%s or %s';
  RsTitleSelectTemporaryDirectory     = 'Destination directory for temporary files:';

  { UCutApplicationVirtualDub }
  RsCutAppInfoVirtualDub              = '%sSmart Rendering: %s'#13#10
                                      + 'Codec for Smart Rendering: %s'#13#10
                                      + 'Codec Version: %s'#13#10;

  { UCutApplicationMP4Box }
  RsCutAppInfoMP4Box                  = '%sOptions: %s'#13#10;

  { UCutApplicationAviDemux }
  RsCutAppInfoAviDemux                = '%sOptions: %s'#13#10
                                      + 'Rebuild Movie Index: %s'#13#10
                                      + 'Scan Audio for VBR: %s'#13#10
                                      + 'Smart Copy: %s'#13#10;

  { UCutApplicationAsfBin }
  RsCutAppInfoAsfBin                  = '%sOptions: %s'#13#10;
  RsFilterDescriptionExecutables      = 'Executable files';

  { mainForm }
  RsLocalCutlist                      = 'Local';
  RsServerCutlist                     = 'Server';

  { UCutApplicationVirtualDub }
  RsCutAppVDPattSmartRender           = 'Cannot initialize smart rendering';
  RsCutAppVDPattSmartRenderNoCodec    = 'No video codec is selected';
  RsCutAppVDPattSmartRenderWrongCodec = 'cannot match the same compressed format';
  RsCutAppVDErrorSmartRenderNoCodec   = 'No codec selected in Settings.'#13#10
                                      + 'Please open settings dialog and select a video codec.';
  RsCutAppVDErrorSmartRenderWrongCodec= 'Wrong codec selected in Settings.'#13#10
                                      + 'Please open settings dialog and select an appropriate video codec.';

  { Main }
  RsMsgServerCommandErrorResponse     = 'Unsupported server response.';
  RsMsgServerCommandErrorCommand      = 'Unsupported server command "%s".';
  RsMsgServerCommandErrorProtocol     = 'Unsupported communication protocol %d.';
  RsMsgServerCommandErrorUnspecified  = 'Unspecified Error.';
  RsMsgServerCommandErrorMySql        = 'MySql Error: %s.';
  RsMsgServerCommandErrorArgMissing   = 'Missing argument in command.';
  RsMsgCutlistRateAlreadyRated        = 'IP did already rated or cutlist uploaded by you.';
  RsUseCustomInfoXml                  = 'You are using the following custom url for update info:'#13#10
                                      + '    %s'#13#10
                                      + 'The new RECOMMENDED standard location is on the cutassistant project server'#13#10
                                      + '    %s'#13#10
                                      + #13#10
                                      + 'Do you want to use the standard url instead of the custom location?';
  RsMsgCutlistReplaceFileInfo         = 'Do you want to adjust the file information of this cutlist'#13#10
                                      + '"%s (%d)"'#13#10
                                      + 'by current file information?';

  // abc874
  RsMergeCutAsk1                      = 'Merge cut %d and %d?';
  RsMergeCutAsk2                      = 'Merge cut %d with previous (%d) or next (%d) cut?';
  RsMergeCutPrev                      = 'Previous';
  RsMergeCutNext                      = 'Next';

  RsSplitCutAsk                       = 'Split cut at current position?';
  RsSplitCutWarn                      = 'Current position not inside cut!';

  RsShiftCutTime                      = 'shift time';

  RsFrames                            = '%d frames (%.2f s)';

  RsInput                             = 'Input';
  RsFileName                          = 'Filename';

  RSIgnorePrefix                      = 'Nothing found. Repeat search ignoring prefix?';

  RSIniInProfile                      = 'Using %s.';

implementation

end.

