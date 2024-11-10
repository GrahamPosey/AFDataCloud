public class CopadoAIPromptLogic {

    private static HttpResponse callCopadoAPI() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.robotic.copado.com/pace/v4/projects/66668/jobs/98389/builds');
        request.setMethod('POST');
        request.setHeader('X-Authorization', 'oH72VYZHdAG8em4Bnr5T21vMdtNZfadqr6A29IbrC4X0kr6A96WE');
        request.setHeader('Content-Type', 'application/json');       
        return http.send(request);
    }

    // private static String processResponse(HttpResponse response) {
    //     if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
    //         System.debug('The following exception occurred: ' + response.getBody());
    //         return 'CRT Script executed successfully. Result: ' + response.getBody();
    //     } else {
    //         System.debug('The following exception occurred: ' + response.getStatus());
    //         return 'Error executing CRT Script. Status: ' + response.getStatus();

    //     }
    // }
    // public static HttpResponse runCRTScript() {
    //     try{
    //         HttpResponse response = callCopadoAPI();        
    //         return response;
    //     } catch (Exception e) {
    //         System.debug('The following exception occurred: ' + e);
    //         //return 'The following exception occurred: ' + e;
    //     }

    // }

    @AuraEnabled(cacheable=true)
    public static String createGeneration(String prompt) {
        String modelsApiResponse = '';
        try {
            if (prompt.contains('Agentforce') || prompt.contains('Data Cloud')) {
                HttpResponse jobRes = callCopadoAPI();
                //System.debug('jobRes: ' + jobRes);
                Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(jobRes.getBody());
                //System.debug('parsedJson: ' + parsedJson);
                Map<String, Object> dataMap = (Map<String, Object>) parsedJson.get('data');
                //System.debug('dataMap: ' + dataMap);
                Integer jobId = (Integer) dataMap.get('jobId'); 
                //System.debug('jobId: ' + jobId);
                modelsApiResponse = 'The configuration job has successfully started. Please prompt me to check the status of the job with the following job id: '+ jobId ;
            } else {
                modelsApiResponse = 'I\'m not sure what you are trying to invoke. You may not need my assistance. If you believe you are receiving this message in error, please contact your System Administrator.';
            }
        } catch(Exception e) {
            System.debug('The following exception occurred: ' + e);
            modelsApiResponse = 'Unable to get a valid response. Error code: ' + e;
        }
        return modelsApiResponse;
    }
}