var evtSource;

function openSSEStream(connectionUrl){
try{
    if(evtSource) closeSSEStream();
    evtSource = new EventSource(connectionUrl, {
      withCredentials: false,
    });
    evtSource.onmessage = (event) => {
      window.manageServerSideEvent(`${event.data}`);
    };
    } catch (e) {
        console.log(e);
    }
}

function closeSSEStream(){
    if(evtSource) {
        try{
            evtSource.close();
        } catch (e) {
            console.log(e);
        }
    }
}
