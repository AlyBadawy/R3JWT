// import React, { useEffect, useRef, useState } from 'react';
// import { useNavigate } from 'react-router-dom';
// import { useAppDispatch } from '../../redux/hooks';
// import { setCredentials } from '../../redux/slices/authSlice';
// import { useLoginMutation } from '../../redux/api/AuthApi';

// export const Login = () => {
//   const userRef = useRef<HTMLInputElement>(null);
//   const errRef = useRef<HTMLParagraphElement>(null);
//   const [user, setUser] = useState('');
//   const [pwd, setPwd] = useState('');
//   const [errMsg, setErrMsg] = useState('');
//   const navigate = useNavigate();

//   const [login, { isLoading }] = useLoginMutation();
//   const dispatch = useAppDispatch();

//   useEffect(() => {
//     userRef.current?.focus();
//   }, []);

//   useEffect(() => {
//     setErrMsg('');
//   }, [user, pwd]);

//   const handleSubmit = async (
//     event: React.MouseEvent<HTMLButtonElement, MouseEvent>
//   ) => {
//     event.preventDefault();
//     try {
//       const userData = await login({ username: user, password: pwd }).unwrap();
//       dispatch(setCredentials({ ...userData, user }));
//       setUser('');
//       setPwd('');
//       navigate('/welcome');
//       // } catch (err) {
//       //   if (!err?.response) {
//       //     setErrMsg('No Server Response');
//       //   } else if (err.response?.status === 402) {
//       //     setErrMsg("Can't process request");
//       //   } else if (err.response?.status === 401) {
//       //     setErrMsg('Invalid Credentials');
//       //   } else {
//       //     setErrMsg('Login Failed');
//       //   }
//       //   errRef.current?.focus();
//     } catch {
//       setErrMsg('Login Failed');
//     }
//   };

//   const content = isLoading ? (
//     <h1>Loading...</h1>
//   ) : (
//     <section>
//       <p ref={errRef}>{errMsg}</p>
//       <h1>Login</h1>
//       <form>
//         <input
//           type="text"
//           id="username"
//           ref={userRef}
//           value={user}
//           onChange={(event) => {
//             setUser(event.target.value);
//           }}
//         />
//         <input
//           type="password"
//           id="password"
//           ref={userRef}
//           value={pwd}
//           onChange={(event) => {
//             setUser(event.target.value);
//           }}
//         />
//         <button onClick={handleSubmit}></button>
//       </form>
//     </section>
//   );

//   return content;
// };
