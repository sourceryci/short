import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';

import API from './api';

const appContainer = document.getElementById('app');

function Result({ longUrl, shortUrl }) {
  const [copyButtonText, setCopyButtonText] = useState('copy');

  useEffect(() => {
     setCopyButtonText('copy');
  }, [shortUrl]);

  if (!shortUrl) {
    return null;
  }

  const copyToClipboard = () => {
    navigator.clipboard.writeText(shortUrl).then(function() {
      setCopyButtonText('copied!')
    }, function() {});
  }

  return (
    <section className="w-5/6 mx-auto mt-8">
      <div>
      The short URL for <span className="text-indigo-400">{longUrl}</span> is:
      </div>

      <div className="mt-4 w-4/5">
        <a href={shortUrl} className="underline text-blue-500">
          {shortUrl}
        </a>

        <button
          type="submit"
          onClick={copyToClipboard}
          className={`w-1/6
            ml-2 px-2 py-2 border border-transparent text-base
            font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 md:py-2
            md:text-lg md:px-2
            `}
          >
          {copyButtonText}
        </button>
      </div>
    </section>
  );
}

function Errors({ errors }) {
  if (!errors) {
    return null;
  }

  errorMessage = (message) => {
    return (
      <li key={message}>{message}</li>
    );
  }

  errorMessages = (errors) => {
    return Object.entries(errors).map(([field, messages]) => {
      return (
        <div key={field}>
          <h4>{field}</h4>
          <ul>
            {messages.map(errorMessage)}
          </ul>
        </div>
      )
    });
  }

  return (
    <div>
    The following issues were found:
    {errorMessages(errors)}
    </div>
  );
}

function App() {
  let [disabled, setDisabled] = useState(true);
  const [buttonText, setButtonText] = useState('shorten');
  const [url, setUrl] = useState('');
  const [shortUrl, setShortUrl] = useState(null);
  const [longUrl, setLongUrl] = useState(null);
  const [errors, setErrors] = useState(null);

  const submitRequest = (e) => {
    e.preventDefault();

    setDisabled(true);

    API.shortenLink(url).then((response) => {
      if (response.ok) {
        response.json().then(({ data }) => {
          setLongUrl(data.url);
          setShortUrl(data.short_url);
          setUrl('');
          setButtonText('shorten another');
        })
      } else {
        response.json().then(({ errors }) => {
          setErrors(errors);
        })
      }
    });
  }

  if (url.match(/https?:\/\/.+/)) {
    disabled = false;
  }

  return (
    <div>
      <form className="w-full" onSubmit={submitRequest}>
        <div className="w-5/6 mx-auto mt-5 sm:mt-8 sm:flex sm:justify-center lg:justify-start">
          <input
            className="w-5/6 text-gray-700 mr-3 py-1 px-2 leading-tight"
            type="url"
            pattern="https?://.*"
            size="32779"
            value={url}
            onChange={(e) => setUrl(e.target.value)}
            placeholder="https://a-very-long-url-to-shorten.org"
            autoFocus/>

          <button
            type="submit"
            className={`w-1/6
              disabled:opacity-60
              flex items-center justify-center px-4 py-3 border border-transparent text-base
              font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 md:py-4
              md:text-lg md:px-4`}
            disabled={disabled}>
            {buttonText}
          </button>
        </div>
      </form>
      <Errors errors={errors} />

      <Result longUrl={longUrl} shortUrl={shortUrl} />
    </div>
  );
}

ReactDOM.render(<App />, appContainer);
